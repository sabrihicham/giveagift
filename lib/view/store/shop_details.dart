import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/pages/ready_card_preview.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';
import 'package:giveagift/view/home/home.dart';
import 'package:giveagift/view/store/controller/shop_controller.dart';
import 'package:giveagift/view/widgets/gift_card.dart';
import 'package:giveagift/view/widgets/global_section_header.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ShopDetailsPage extends StatefulWidget {
  final String shopId, shopName;

  const ShopDetailsPage(
      {super.key, required this.shopId, required this.shopName});

  @override
  State<ShopDetailsPage> createState() => _ShopDetailsPageState();
}

class _ShopDetailsPageState extends State<ShopDetailsPage> {
  final ShopController controller = Get.put(ShopController());

  @override
  void initState() {
    controller.fetchShopDetails(widget.shopId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.isDarkMode ? Colors.black : null,
      child: Scaffold(
        backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
        appBar: AppBar(
          backgroundColor: Get.isDarkMode ? null : Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Text(
            widget.shopName,
          ),
        ),
        body: GetBuilder<ShopController>(
            init: controller,
            id: '${widget.shopId}_shop_details',
            builder: (controller) {
              if (controller.getShopDetailsState(widget.shopId) is Submitting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              
              if (controller.getShopDetailsState(widget.shopId)
                  is SubmissionError) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (controller.getShopDetailsState(widget.shopId) as SubmissionError).exception.message,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        controller.fetchShopDetails(widget.shopId);
                      },
                      child: Text('retry'.tr),
                    ),
                  ],
                );
              }
              
              if (controller.shopsDetails[widget.shopId] == null) {
                return const Center(
                  child: Text('لا بيانات متاجر'),
                );
              }
              
              final shopDetails = controller.shopsDetails[widget.shopId]!;
              
              // return MasonryGridView.builder(
              //   itemCount: store.length,
              //   padding: const EdgeInsets.symmetric(
              //     horizontal: 10,
              //     vertical: 20,
              //   ),
              //   gridDelegate:
              //       SliverSimpleGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount:
              //         MediaQuery.of(context).size.width > 600 ? 3 : 2,
              //   ),
              //   itemBuilder: (context, index) {
              //     return ShopWidget(
              //       store: store.elementAt(index),
              //     );
              //   },
              // );
              
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      // height: 274,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Theme.of(context).cardColor
                            : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Get.isDarkMode
                                ? Colors.white12
                                : Color(0x3FECEBEB),
                            blurRadius: 17.60,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 71.w,
                            child: CupertinoButton(
                              onPressed: () {
                                if (shopDetails.shop.link != null) {
                                  launchUrlString(shopDetails.shop.link!);
                                }
                              },
                              padding: EdgeInsets.zero,
                              child: Stack(
                                children: [
                                  BrandImage(
                                    logoImage: shopDetails.shop.logo.shopImage,
                                    size: 71.w,
                                    margin: EdgeInsets.zero,
                                    fit: BoxFit.fill,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 24.w,
                                      height: 24.w,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 8,
                                      ),
                                      decoration: ShapeDecoration(
                                        color: const Color(0xFF222A40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/icons/fluent_open.svg',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            shopDetails.shop.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade300
                                  : const Color(0xFF222A40),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            shopDetails.shop.description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFBDBDBD),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GlobalSectionHeader(
                      title: "custom_cards".tr,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    TitledCard(
                      title: 'custom_cards'.tr,
                      width: 175.w,
                      margin: const EdgeInsets.only(bottom: 20),
                      content: GiftCard(
                        frontBackgroundImage: "assets/images/custom-front-shape.png",
                        isFrontAssets: true,
                        frontBackgroundImageFit: BoxFit.fill,
                        backBackgroundImage: "assets/images/custom-back-shape.png",
                        isBackAssets: true,
                        backForegroundImageFit: BoxFit.fill,
                        borderRadius: 10.r,
                      ),
                      onTap: () {
                        // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                        // cardsPageKey.currentState?.changeTab(CardType.custom);
                        Get.to(
                          () => Scaffold(
                            backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
                            body: CardsPage(
                              initialTab: CardType.custom,
                              shop: shopDetails.shop,
                            ),
                          ),
                        );
                      },
                    ),
                    GlobalSectionHeader(
                      title: "ready_cards".tr,
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: StaggeredGrid.count(
                        // shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 5,
                        children: List.generate(
                          shopDetails.readyCards.length,
                          (index) {
                            final card = shopDetails.readyCards[index];
                            card.frontShape = shopDetails.frontShapeImagePath;
                            card.backShape = shopDetails.backShapeImagePath;
                            return GestureDetector(
                                onTap: () {
                                  Get.to(() => ReadyCardPreview(card: card, shopId: widget.shopId,));
                                },
                                child: SizedBox(
                                  // width: 270,
                                  child: ReadyCard(
                                    card: card,
                                    shopId: widget.shopId,
                                    onAddTap: () {
                                      Get.to(() => ReadyCardPreview(card: card, shopId: widget.shopId,));
                                    },
                                  ),
                                ));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
