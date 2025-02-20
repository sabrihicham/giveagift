import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/cards.dart';
import 'package:giveagift/view/cards/controller/cards_controller.dart';
import 'package:giveagift/view/cards/pages/ready_card_preview.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/cards/widgets/ready_card.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/payment/success_page.dart';
import 'package:giveagift/view/profile/wallet.dart';
import 'package:giveagift/view/store/controller/shop_controller.dart';
import 'package:giveagift/view/store/shop.dart';
import 'package:giveagift/view/store/shop_details.dart';
import 'package:giveagift/view/widgets/global_section_header.dart';
import 'package:giveagift/view/widgets/search_bar.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({
    super.key,
  });

  @override
  State<ExplorePage> createState() => ExplorePageState();
}

class ExplorePageState extends State<ExplorePage> {
  final controller = Get.put(CardsController());
  final cartController = Get.put(CartController());
  final shopController = Get.put(ShopController());

  @override
  void initState() {
    super.initState();
  }

  Widget LatestCardsView(CardsController controller, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150.w,
      child: GetBuilder(
          init: controller,
          id: CardType.readyToUse.name,
          builder: (controller) {
            if (controller.readyCardsSourceRepository.isLoading) {
              return const CupertinoActivityIndicator();
            }

            return controller.readyCardsSourceRepository.isEmpty
                ? Center(child: Text('no_data'.tr))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.readyCardsSourceRepository.length,
                    itemBuilder: (context, index) {
                      final card = controller.readyCardsSourceRepository[index];
                      return Padding(
                        padding: EdgeInsets.only(left: 8.w, right: 8.w),
                        child: GestureDetector(
                            onTap: () {
                              Get.to(() => ReadyCardPreview(card: card, shopId: card.shop!.id));
                            },
                            child: SizedBox(
                              width: 165.w,
                              child: ReadyCard(
                                card: card,
                                shopId: card.shop!.id,
                                onAddTap: () {
                                  Get.to(() => ReadyCardPreview(card: card, shopId: card.shop!.id));
                                },
                              ),
                            )),
                      );
                    },
                  );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Get.isDarkMode ? Theme.of(context).cardColor : Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        notificationPredicate: (notification) {
          return notification is OverscrollIndicatorNotification;
        },
        elevation: 0,
        title: SvgPicture.asset(
          'assets/images/logo.svg',
          width: 63.07.w,
        ),
        toolbarHeight: 70,
        leading: Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(174, 174, 174, 0.1),
              shape: BoxShape.circle,
            ),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Get.to(() => const WalletPage());
              },
              child: SvgPicture.asset(
                'assets/icons/solar_wallet-linear.svg',
                width: 24.w,
                color: Get.isDarkMode ? Colors.white : null,
              ),
            )),
        leadingWidth: 70,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GetBuilder(
              init: cartController,
              didChangeDependencies: (controller) {
                if (SharedPrefs.instance.isLogedIn.value &&
                    controller.controller?.defaultState is SubmissionError) {
                  Get.snackbar(
                    'Error',
                    (controller.controller!.defaultState as SubmissionError)
                        .exception
                        .message,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
              builder: (controller) {
                return Directionality(
                  textDirection: TextDirection.ltr,
                  child: Badge(
                    label: Text(
                      '${cartController.cards?.where((element) => element.isPaid == false).length ?? "0"}',
                    ),
                    isLabelVisible: true,
                    backgroundColor: Colors.redAccent,
                    offset: const Offset(-5, 5),
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      disabledColor: Colors.transparent,
                      onPressed: () {
                        Get.to(
                          () => CartPage(key: cartPageKey),
                          duration: Get.isDarkMode ? 0.seconds : null
                        );
                        // appNavigationKey.currentState?.changeSelectedTab(Pages.cart);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(174, 174, 174, 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/solar_bag-linear.svg',
                          width: 24.w,
                          color: Get.isDarkMode ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              margin: const EdgeInsets.only(
                  top: 30, bottom: 10, left: 16, right: 16),
              onSearch: (value) {
                controller.readyCardsSourceRepository.emptyFilter();
                controller.readyCardsSourceRepository.searchText = value;
                Get.find<CardsController>().filterReadyCardsLocaly();
              },
            ),
            Container(
              color: Colors.white,
              child: Container(
                color: Get.isDarkMode
                    ? Colors.black.withOpacity(0.9)
                    : Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GlobalSectionHeader(
                        title: 'categories'.tr,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    // SectionHeader(
                    //   title: 'categories'.tr,
                    //   onMore: () {
                    //     // Get.toNamed(Routes.categories);
                    //   },
                    // ),
                    SizedBox(
                      height: 100.w,
                      child: GetBuilder<CardsController>(
                          init: controller,
                          id: 'categories',
                          builder: (controller) {
                            if (controller.categoriesState is Submitting) {
                              return const CupertinoActivityIndicator();
                            } else if (controller.categoriesState
                                is SubmissionError) {
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (controller.categoriesState
                                              as SubmissionError)
                                          .exception
                                          .message,
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        controller.fetchCategories();
                                      },
                                      child: Text('retry'.tr),
                                    )
                                  ],
                                ),
                              );
                            }

                            if (controller.categoriesResponse == null ||
                                controller.categoriesResponse!.data.isEmpty) {
                              return SizedBox(
                                height: 100.h,
                                width: double.infinity,
                                child: Text(
                                  'no_categories_found'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 100.h,
                              width: double.infinity,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: controller
                                        .categoriesResponse?.data.length ??
                                    0,
                                // itemExtent: 96,
                                itemBuilder: (context, index) {
                                  final category = controller
                                      .categoriesResponse!.data[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8),
                                    child: CupertinoButton(
                                      onPressed: () {
                                        // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                                        // cardsPageKey.currentState?.changeTab(CardType.readyToUse);

                                        // appNavigationKey.currentState?.changeSelectedTab(Pages.stores);
                                        // shopViewKey.currentState?.filterByCategory(category);

                                        Get.to(
                                          () => ShopView(category: category),
                                          duration: Get.isDarkMode ? 0.seconds : null
                                        );
                                      },
                                      padding: EdgeInsets.zero,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 60.w,
                                            height: 60.w,
                                            padding: const EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? Colors.grey.shade900
                                                  : const Color(0xFFF9F9FB),
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  category.icon.categoryImage,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            Get.locale?.languageCode == 'ar' ||
                                                    category.enName == null
                                                ? category.name
                                                : category.enName!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 10.sp,
                                                    height: 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(
                        title: 'popular_shops'.tr,
                        onMore: () {
                          // appNavigationKey.currentState?.changeSelectedTab(Pages.stores);
                          // shopViewKey.currentState?.clearFilter();

                          Get.to(
                            () => const ShopView(),
                            duration: Get.isDarkMode ? 0.seconds : null
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100.w,
                      child: GetBuilder(
                          init: shopController,
                          builder: (context) {
                            if (shopController.defaultState is Submitting) {
                              return const CupertinoActivityIndicator();
                            } else if (shopController.defaultState is SubmissionError) {
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (shopController.defaultState
                                              as SubmissionError)
                                          .exception
                                          .message,
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        shopController.fetchShops();
                                      },
                                      child: Text('retry'.tr),
                                    )
                                  ],
                                ),
                              );
                            }

                            final homeShops = shopController.shops.values.firstOrNull?.where((store) => store.showInHome ?? false).toList();

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: homeShops?.length ?? 0,
                              itemBuilder: (context, index) {
                                final shop = homeShops![index];
                                return Padding(
                                  padding: EdgeInsets.only(right: 8.w, left: 8.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CupertinoButton(
                                        onPressed: () {
                                          Get.to(() => ShopDetailsPage(
                                            shopId: shop.id,
                                            shopName: shop.name,
                                          ),
                                        );
                                        },
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          width: 72.w,
                                          height: 72.w,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                              ? Colors.grey.shade100
                                              : Colors.white,
                                            borderRadius: BorderRadius.circular(20.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Get.isDarkMode
                                                  ? Colors.grey[850]!
                                                  : Colors.grey[300]!,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: BrandImage(
                                            logoImage: shop.logo.shopImage,
                                            size: 35,
                                            margin: const EdgeInsets.symmetric(horizontal: 0),
                                            fit: BoxFit.fill,
                                            clipBehavior: Clip.none,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        shop.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(
                        title: 'latest_cards'.tr,
                        onMore: () {
                          // appNavigationKey.currentState?.changeSelectedTab(Pages.cards);
                          // cardsPageKey.currentState?.changeTab(CardType.readyToUse);
                          // cardsPageKey.currentState?.changeReadyCardsAppBar(title: 'latest_cards'.tr);

                          Get.to(() => CardsPage(
                            initialTab: CardType.readyToUse,
                            title: 'latest_cards'.tr,
                          ));
                        },
                      ),
                    ),
                    Builder(builder: (context) {
                      return LatestCardsView(controller, context);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SectionHeader(
                        title: 'offers'.tr,
                        // onMore: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GetBuilder<CardsController>(
                          init: controller,
                          id: 'ads',
                          builder: (context) {
                            if (controller.adsState is Submitting) {
                              return const CupertinoActivityIndicator();
                            } else if (controller.adsState is SubmissionError) {
                              return SizedBox(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      (controller.adsState as SubmissionError).exception.message,
                                    ),
                                    CupertinoButton(
                                      onPressed: () {
                                        controller.fetchAds();
                                      },
                                      child: Text('retry'.tr),
                                    )
                                  ],
                                ),
                              );
                            }

                            if (controller.adsResponse == null ||
                                controller.adsResponse!.data.isEmpty) {
                              return SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'no_ads_found'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12.sp),
                                ),
                              );
                            }

                            return StaggeredGrid.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 13.w,
                              mainAxisSpacing: 8.w,
                              children: [
                                for (int i = 0;
                                    i < controller.adsResponse!.data.length;
                                    i++)
                                  CupertinoButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      launchUrlString(
                                          controller.adsResponse!.data[i].link);
                                    },
                                    child: Container(
                                      width: 165.w,
                                      height: i % 3 == 1 ? 338.w : 165.w,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      child: CachedNetworkImage(
                                        imageUrl: controller.adsResponse!
                                            .data[i].image.adsImage,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final void Function()? onMore;

  const SectionHeader({
    super.key,
    required this.title,
    this.onMore,
  });

  Color get moreColor =>
      Get.isDarkMode ? Colors.white : Get.theme.colorScheme.secondary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.sp,
                ),
              ),
              const SizedBox(width: 10),
              SvgPicture.asset(
                'assets/images/logo.svg',
                width: 40.w,
              ),
            ],
          ),
          if (onMore != null)
            CupertinoButton(
              onPressed: onMore,
              padding: EdgeInsets.zero,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'show_all'.tr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: moreColor,
                      fontSize: 12.sp,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: moreColor,
                    size: 16.w,
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
