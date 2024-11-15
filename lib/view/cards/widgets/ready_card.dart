import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/pages/ready_card_preview.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/store/shop_details.dart';
import 'package:giveagift/view/widgets/gift_card.dart';

class ReadyCard extends StatefulWidget {
  const ReadyCard({
    super.key,
    required this.card,
    required this.shopId,
    required this.onAddTap,
  });

  final CardData card;
  final String shopId;
  final void Function() onAddTap;

  @override
  State<ReadyCard> createState() => _ReadyCardState();
}

class _ReadyCardState extends State<ReadyCard>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final GestureFlipCardController controller = GestureFlipCardController();
    return SizedBox(
      // width: 480,
      // height: 270,
      child: Container(
        // color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        decoration: BoxDecoration(
          color: Get.isDarkMode
            ? Colors.grey[900]
            : Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                Get.to(
                  () => ReadyCardPreview(card: widget.card, shopId: widget.shopId,),
                  duration: Get.isDarkMode ? 0.seconds : null
                );
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => ReadyCardPreview(card: widget.card,shopId: widget.shopId),
                //   ),
                  
                // );
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 4.w, right: 4.w, left: 4.w),
                child: GiftCard(
                  controller: controller,
                  frontBackgroundImage: '${API.BASE_URL}/${widget.card.frontShape!}',
                  backBackgroundImage: '${API.BASE_URL}/${widget.card.backShape!}',
                  showOnly: CardSide.front,
                  borderRadius: 10.r,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 24.w,
                    width: 24.w,
                    child: CupertinoButton(
                      onPressed: widget.onAddTap,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(30),
                      color: Theme.of(context).primaryColor,
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'SAR',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Get.isDarkMode ? Colors.white : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${widget.card.price}",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 5),
                      BrandImage(
                        logoImage: widget.card.shop?.logo.shopImage ?? '',
                        onTap: () {
                          // widget.card.shop?.launchShop();
                          final shop = widget.card.shop!;
                          Get.to(() => ShopDetailsPage(shopId: shop.id, shopName: shop.name));
                        },
                        backgroundColor: Colors.white,
                        margin: EdgeInsets.zero,
                        fit: BoxFit.fill,
                        size: 24.w,
                      ),
                    ].reversed.toList(),
                  )
                ].reversed.toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
