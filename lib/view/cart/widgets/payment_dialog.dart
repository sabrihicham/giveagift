import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/cart/data/model/card.dart';

import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/view/widgets/global_filled_button.dart';

class GlobalDialog extends StatefulWidget {
  final String? title, doneText, cancelText;
  final List<Widget> content;
  final Function()? onDonePressed, onCanclePressed;
  const GlobalDialog(
      {super.key,
      this.title,
      this.doneText,
      this.cancelText,
      this.content = const [],
      this.onDonePressed,
      this.onCanclePressed});

  @override
  State<GlobalDialog> createState() => _GlobalDialogState();
}

class _GlobalDialogState extends State<GlobalDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: 16.w,
        vertical: 16.w,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.only(top: 21.h, left: 9.w, right: 13.w, bottom: 11.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: Get.isDarkMode
                        ? Colors.white
                        : Get.theme.colorScheme.secondary,
                  ),
                ),
              const SizedBox(height: 20),
              ...widget.content,
              SizedBox(height: 27.h),
              Row(
                children: [
                  Expanded(
                    child: GlobalFilledButton(
                        height: 52.h,
                        color: Colors.transparent,
                        onPressed: widget.onCanclePressed ?? () => Get.back(),
                        text: widget.cancelText ?? 'cancel'.tr,
                        textColor: Get.isDarkMode
                            ? Colors.white
                            : Theme.of(context).colorScheme.secondary,
                        enableBorder: true),
                  ),
                  SizedBox(width: 37.w),
                  Expanded(
                    child: GlobalFilledButton(
                      height: 52.h,
                      onPressed: widget.onDonePressed ?? () => Get.back(),
                      text: widget.doneText ?? 'done'.tr,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({
    super.key,
    required this.card,
  });

  final Card card;

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final couponCode = TextEditingController();
  Color get iconColor => Get.isDarkMode
      ? const Color.fromARGB(255, 138, 176, 203)
      : const Color.fromRGBO(106, 126, 140, 1);
  final textStyle = const TextStyle(fontSize: 24);
  bool isPayment = true;

  Widget _buildInfo(String key, String value, String assetPath) {
    return Container(
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Get.isDarkMode ? Colors.grey[500] : Color(0xFFF9F9F9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  padding: EdgeInsets.all(6.w),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: SvgPicture.asset(
                    assetPath,
                    height: 24.w,
                    width: 24.w,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(width: 13),
                Text(
                  key,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GlobalDialog(
      title: 'select_payment_method'.tr,
      doneText: 'pay'.tr,
      onDonePressed: () {
        Navigator.of(context).pop(isPayment);
      },
      content: [
        _buildInfo(
          'card_price'.tr,
          '${widget.card.price!.value.toStringAsFixed(2)} ${'sar'.tr}',
          'assets/icons/money-line.svg',
        ),
        const SizedBox(height: 8),
        // Celebration Icon
        if (widget.card.proColor != null)
          Column(
            children: [
              _buildInfo(
                'color_price'.tr,
                '${widget.card.proColor?.price.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                'assets/icons/hugeicons_gift.svg',
              ),
              const SizedBox(height: 8),
            ],
          ),
        if (widget.card.shapes != null &&
            widget.card.shapes!.any((element) => element.shape.price != null))
          Column(
            children: [
              _buildInfo(
                'shape_price'.tr,
                '${widget.card.shapes!.fold(0.0, (prev, value) => prev + (value.shape.price ?? 0)).toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                'assets/icons/hugeicons_gift.svg',
              ),
              const SizedBox(height: 8),
            ],
          ),
        if (widget.card.celebrateIcon != null)
          Column(
            children: [
              _buildInfo(
                'celebration_shape'.tr,
                '${SharedPrefs.instance.appConfig?.celebrateIconPrice?.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                'assets/icons/hugeicons_gift.svg',
              ),
              const SizedBox(height: 8),
            ],
          ),
        if (widget.card.celebrateQR != null)
          Column(
            children: [
              _buildInfo(
                'celebration_link'.tr,
                '${SharedPrefs.instance.appConfig?.celebrateLinkPrice?.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                'assets/icons/hugeicons_gift.svg',
              ),
              const SizedBox(height: 8),
            ],
          ),
        // VAT %
        _buildInfo(
          'vat'.tr,
          '${widget.card.vat} ${'sar'.tr}',
          'assets/icons/receipt-tax.svg',
        ),
        const SizedBox(height: 8),
        // Total Price
        _buildInfo(
          'total_price'.tr,
          isPayment
              ? widget.card.totalWithVat.toStringAsFixed(2)
              : widget.card.totalWithVat > SharedPrefs.instance.wallet!.balance
                  ? (widget.card.totalWithVat -
                          SharedPrefs.instance.wallet!.balance)
                      .toStringAsFixed(2)
                  : widget.card.totalWithVat.toStringAsFixed(2),
          'assets/icons/dollar.svg',
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: OutlineContainer(
                title: 'payment_method'.tr,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                width: double.infinity,
                height: 52.h,
                radius: 11.r,
                borderColor: isPayment
                    ? Get.isDarkMode
                        ? null
                        : Get.theme.colorScheme.secondary
                    : Get.isDarkMode
                        ? Get.theme.colorScheme.secondary
                        : null,
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isPayment = true;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'payment'.tr,
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 9.w),
            Flexible(
              child: OutlineContainer(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                width: double.infinity,
                height: 52.h,
                radius: 11.r,
                borderColor: !isPayment
                    ? Get.isDarkMode
                        ? null
                        : Get.theme.colorScheme.secondary
                    : Get.isDarkMode
                        ? Get.theme.colorScheme.secondary
                        : null,
                child: CupertinoButton(
                  onPressed: () {
                    setState(() {
                      isPayment = false;
                    });
                  },
                  padding: EdgeInsets.zero,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        Text(
                          'wallet'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '(${SharedPrefs.instance.wallet?.balance.toStringAsFixed(2) ?? "--"} ${'sar'.tr})',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Cupon Code
        SizedBox(height: 18.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: GlobalOutlineTextFeild(
                controller: couponCode,
                title: 'coupon_code'.tr,
                height: 52.h,
              ),
            ),
            SizedBox(width: 4.w),
            GlobalFilledButton(
              text: 'apply'.tr,
              height: 52.h,
              width: 92.w,
              onPressed: () async {
                final response = await client.put(
                  Uri.parse(
                      '${API.BASE_URL}/api/v1/cards/${widget.card.id}/apply-coupon'),
                  body: {
                    'couponCode': couponCode.text,
                  },
                );

                final body = jsonDecode(response.body);

                if (response.statusCode == 200) {
                  final data = body['data'];
                  try {
                    setState(() {
                      widget.card.priceAfterDiscount =
                          data['priceAfterDiscount'];
                    });
                  } catch (e) {
                    log(e.toString());
                  }
                }

                Get.snackbar(
                  'coupon'.tr,
                  response.statusCode == 200
                      ? "coupon_apply_succ"
                      : body['message'] ??
                          'An error occurred while applying coupon.',
                  backgroundColor: response.statusCode == 200
                      ? Colors.greenAccent
                      : Colors.redAccent,
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
