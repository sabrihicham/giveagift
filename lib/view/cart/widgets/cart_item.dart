import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cart/card_preview.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/model/execute_payment.dart';
import 'package:giveagift/view/cart/recepient_info.dart';
import 'package:giveagift/view/cart/widgets/payment_dialog.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:giveagift/view/payment/success_page.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/orders.dart';

class CartItem extends StatefulWidget {
  final Card card;
  final Function(Card card)? onRemove;

  const CartItem({super.key, required this.card, this.onRemove});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Color iconsColor = const Color.fromRGBO(106, 126, 140, 1);

  void _onPaySuccess() async {
    appNavigationKey.currentState?.changeSelectedTab(Pages.profile);

    Get.find<CartController>().getCards();

    await Get.to(() => Successful(card: widget.card));

    Get.to(() => const OrdersPage());
  }

  void _onPayFailed() {
    print("Failed");
  }

  void _onPay(Card card) async {
    if (card.recipient == null ||
        card.recipient!.name == null ||
        card.recipient!.whatsappNumber == null) {
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecepientInfoPage(card: card),
        ),
      );

      // if (result != true) {
        return;
      // }
    }

    final type = await showDialog(
      context: context,
      builder: (context) {
        return PaymentDialog(
          card: card,
        );
      },
    );

    if (type == null) {
      return;
    }

    bool success = false;

    if (type) {
      final _success = await Get.to(() => PaymentPage(
        card: card,
        amount: card.price!.value,
        type: PaymentType.PAYMENT,
      ));

      success = _success == true;
    } else {
      final profileController = Get.find<ProfileController>();

      await OverlayUtils.showLoadingOverlay(
        text: 'paying'.tr,
        asyncFunction: () async {
          await profileController.buyCard(card.id);
          success = profileController.buyCardState is SubmissionSuccess;
        },
      );

      Get.snackbar(
        success ? "success".tr : "error".tr,
        success
            ? "payment_success".tr
            : profileController.buyCardState is SubmissionError
                ? (profileController.buyCardState as SubmissionError)
                    .exception
                    .message
                : "An error occurred while paying.",
        backgroundColor: success ? Colors.greenAccent : Colors.redAccent,
      );
    }

    if (mounted) {
      setState(() {});
    }

    if (success) {
      _onPaySuccess();
    }
  }

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
                    CartInfo(
                      title: '${'store'.tr}: ',
                      value: widget.card.shop?.name ?? '-',
                      textColor: textColor,
                      icon: SvgPicture.asset(
                        'assets/icons/store.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    CartInfo(
                      title: '${'price'.tr}: ',
                      value: ('${widget.card.price!.value.toStringAsFixed(2)} ${'sar'.tr}'),
                      textColor: textColor,
                      icon: SvgPicture.asset(
                        'assets/icons/dollar.svg',
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    CartInfo(
                        title: widget.card.isDelivered == true
                            ? 'delivered'.tr
                            : 'not_delivered'.tr,
                        value: '',
                        textColor: textColor,
                        icon: SvgPicture.asset(
                          'assets/icons/not_delivered.svg',
                          color: Theme.of(context).primaryColor,
                        )),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle),
                      child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            final result =
                                await DialogUtils.globalShowDialog<bool?>(
                                    title: 'remove_card'.tr,
                                    confirmText: "delete".tr,
                                    content: [
                                  FittedBox(
                                      child: Text('remove_card_message'.tr)),
                                ]);

                            if (result == true) {
                              widget.onRemove?.call(widget.card);
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons/delete.svg',
                            height: 18.w,
                            width: 18.w,
                          )),
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
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: CupertinoButton(
                        onPressed: () => _onPay(widget.card),
                        padding: EdgeInsets.zero,
                        child: Icon(
                          Icons.arrow_forward,
                          size: 24.w,
                          color: Colors.white,
                        ),
                      ),
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

class CartInfo extends StatelessWidget {
  final String title, value;
  final Widget icon;
  final Color? textColor;

  const CartInfo({
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
