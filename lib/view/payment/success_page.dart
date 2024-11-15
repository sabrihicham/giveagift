import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';

class Successful extends StatelessWidget {
  final Card? card;

  const Successful({super.key, this.card});

  String formatDate(DateTime? date) {
    if (date == null) {
      return '----/--/--';
    }

    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  String formatTime(DateTime? date) {
    if (date == null) {
      return 'now'.tr;
    }

    return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 375.w,
            height: 812.h,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -MediaQuery.of(context).padding.top,
                  child: Container(
                    width: 375.w,
                    height: 430.h,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(),
                    child: SvgPicture.asset(
                      'assets/images/congraturation.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 93.h,
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 86.w,
                          height: 86.w,
                          child: SvgPicture.asset(
                            'assets/images/firework.svg',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 98.h,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'شكرا على شرائك!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'بطاقتك قيد الإرسال،ونتمنى أن تجلب السعادة\nلمن تهديها. نحن نقدر دعمك ونتمنى لك يوما رائعاً!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF333333),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 309.h,
                  child: Container(
                    width: 343.w,
                    padding: EdgeInsets.only(
                      top: 7.h,
                      // left: 110.w,
                      // right: 111.w,
                      bottom: 6.h,
                    ),
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF9F9FB),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1.w, color: const Color(0xEEEEEEEE)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: Text(
                                  'الرصيد الحالي',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(height: 4.h),
                              GetBuilder(
                                init: Get.find<ProfileController>(),
                                id: 'wallet',
                                builder: (controller) {
                                  if (controller.walletState is Submitting) {
                                    return const SizedBox(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    );
                                  }

                                  return SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      "${SharedPrefs.instance.wallet?.balance.toStringAsFixed(2) ?? 0} ${'sar'.tr}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: const Color(0xFF333333),
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 404.h,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    width: 343.w,
                    decoration: ShapeDecoration(
                      color: Color(0xFFF9F9FB),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1.w, color: Color(0xEEEEEEEE)),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(16.w),
                          width: 375.w,
                          height: 308.h,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SuccessInfo(
                                  info: '${'card_price'.tr}:',
                                  value:
                                      '${card?.price!.value.toString() ?? '-'} ${'sar'.tr}',
                                  assetPath: 'assets/icons/dollar.svg',
                                ),
                                SuccessInfo(
                                  info: '${'shop'.tr}:',
                                  value: card?.shop?.name ?? '-',
                                  assetPath: 'assets/icons/store.svg',
                                ),
                                SuccessInfo(
                                  info: '${'receiver_name'.tr}:',
                                  value: card?.recipient?.name ?? '-',
                                  assetPath: 'assets/icons/profile.svg',
                                ),
                                SuccessInfo(
                                  info: '${'receiver_whats'.tr}:',
                                  value: card?.recipient?.whatsappNumber ?? '-',
                                  assetPath: 'assets/icons/whatsapp.svg',
                                ),
                                SuccessInfo(
                                  info: '${'date'.tr}:',
                                  value: formatDate(card?.receiveAt),
                                  assetPath: 'assets/icons/date.svg',
                                ),
                                SuccessInfo(
                                  info: '${'time'.tr}:',
                                  value: formatTime(card?.receiveAt),
                                  assetPath: 'assets/icons/time.svg',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 722.h,
                  child: SizedBox(
                    width: 343.w,
                    child: CupertinoButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              height: 60.h,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 15.h),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF222A40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x33111F3A),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'done'.tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SuccessInfo extends StatelessWidget {
  final String assetPath, info, value;

  const SuccessInfo({
    super.key,
    required this.assetPath,
    required this.info,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          padding: const EdgeInsets.all(4),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Container(
              width: 18.w,
              height: 18.w,
              padding: EdgeInsets.only(
                top: 0.35.w,
                left: 2.88.w,
                right: 2.89.w,
                bottom: 0.35.w,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(),
              child: SvgPicture.asset(
                assetPath,
                color: Theme.of(context).primaryColor,
              )),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 13.w),
            Text(
              info,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Spacer(),
        Text(
          value,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: Colors.black,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
