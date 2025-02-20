
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cart/card_preview.dart';
import 'package:giveagift/view/recivedCards/model/recived_card.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecivedCardItem extends StatefulWidget {
  final RecivedCard card;

  const RecivedCardItem({super.key, required this.card});

  @override
  State<RecivedCardItem> createState() => RecivedCardItemState();
}

class RecivedCardItemState extends State<RecivedCardItem> {
  Color iconsColor = const Color.fromRGBO(106, 126, 140, 1);

  Color? get color => widget.card.isSpecial
      ? (Get.isDarkMode
        ? Colors.grey[900]!
        : Theme.of(context).colorScheme.secondary.withOpacity(0.8))
      : widget.card.color?.color.withOpacity(0.7) ?? (Get.isDarkMode ? Colors.grey[900]! : Colors.white);

  Color get textColor => widget.card.proColor != null
      ? Colors.white
      : (color?.computeLuminance() ?? 0) > 0.5
        ? Colors.black
        : Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 189.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Get.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (widget.card.proColor != null)
            Container(
              clipBehavior: Clip.antiAlias,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: widget.card.proColor!.image.endsWith('.svg')
                  ? SvgPicture.asset(
                      widget.card.proColor!.image.colorImage,
                      fit: BoxFit.fill,
                    )
                  : CachedNetworkImage(
                      imageUrl: widget.card.proColor!.image.colorImage,
                      fit: BoxFit.fill,
                    ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 8.w),
            child: Column(
              children: [
                Column(
                  children: [
                    CardInfo(
                      title: '${'store'.tr}: ',
                      value: widget.card.shop?.name ?? '-',
                      textColor: textColor,
                      icon: SvgPicture.asset(
                        'assets/icons/store.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    CardInfo(
                      title: '${'price'.tr}: ',
                      value: ('${widget.card.price!.value.toStringAsFixed(2)} ${'sar'.tr}'),
                      textColor: textColor,
                      icon: SvgPicture.asset(
                        'assets/icons/dollar.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    // SizedBox(height: 4.h),
                    // CardInfo(
                    //     title: widget.card.isDelivered == true
                    //         ? 'delivered'.tr
                    //         : 'not_delivered'.tr,
                    //     value: '',
                    //     textColor: textColor,
                    //     icon: SvgPicture.asset(
                    //       'assets/icons/not_delivered.svg',
                    //       color: Theme.of(context).primaryColor,
                    //     )),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 36.w,
                      height: 36.w,
                    ),
                    // View
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            color: Get.isDarkMode
                                ? Colors.grey[800]!
                                : Colors.white,
                            borderRadius: BorderRadius.circular(100.r)),
                        child: CupertinoButton(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100.r),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              showModalBottomSheet(
                                enableDrag: false,
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                                ),
                                backgroundColor: Get.isDarkMode
                                    ? Colors.grey.shade900
                                    : const Color(0xFFF9F9FB),
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
                                  child: CardPreview(cardId: widget.card.id)
                                )
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/eye.svg',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 18.w,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'view_card'.tr,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.sp),
                                ),
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 36.w,
                      height: 36.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardInfo extends StatelessWidget {
  final String title, value;
  final Widget icon;
  final Color? textColor;

  const CardInfo({
    super.key,
    required this.title,
    required this.icon,
    this.value = '-',
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          padding: EdgeInsets.all(9.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: icon,
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 12.sp, 
            fontWeight: FontWeight.w500,
            color: textColor
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp, 
            fontWeight: FontWeight.w500,
            color: textColor
          ),
        )
      ],
    );
  }
}