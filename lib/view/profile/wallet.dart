import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/profile.dart';
import 'package:giveagift/view/profile/transfer_balance.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return GetBuilder<ProfileController>(
        init: profileController,
        builder: (controller) {
          return Scaffold(
            backgroundColor:
                Get.isDarkMode ? Theme.of(context).cardColor : null,
            appBar: AppBar(
              title: Text(
                'my_wallet'.tr,
              ),
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
            ),
            body: !controller.isLoggedIn.value
                ? NotLogedIn(
                    onLogIn: (value) {
                      if (value) {
                        setState(() {});
                        controller.onInit();
                      }
                    },
                  )
                : RefreshIndicator.adaptive(
                    onRefresh: () async {
                      await controller.onRefresh();
                    },
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height <
                              MediaQuery.of(context).size.width
                          ? MediaQuery.of(context).size.width
                          : MediaQuery.of(context).size.height -
                              (MediaQuery.of(context).padding.top +
                                  MediaQuery.of(context).padding.bottom),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const WalletView(),
                              Flexible(
                                child: Container(
                                  padding: EdgeInsets.all(16.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'previous_transactions'.tr,
                                        style: TextStyle(
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : const Color(0xFF222A40),
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          for (final transfer in SharedPrefs
                                              .instance.wallet!.transfers)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 17.h / 2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Container(
                                                        width: 40.w,
                                                        height: 40.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(255,
                                                              249, 249, 251),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: Stack(
                                                          children: [
                                                            Positioned(
                                                              left: 10.w,
                                                              top: 10.w,
                                                              child: SizedBox(
                                                                width: 20.w,
                                                                height: 20.w,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                16.11.w,
                                                                            height:
                                                                                18.12.w,
                                                                            child:
                                                                                SvgPicture.asset('assets/icons/box.svg'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 10.w),
                                                      SizedBox(
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${'transfer_no'.tr} ${SharedPrefs.instance.wallet!.transfers.indexOf(transfer) + 1}',
                                                              style: TextStyle(
                                                                color: const Color(
                                                                    0xFF040B14),
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Opacity(
                                                                  opacity: 0.50,
                                                                  child: Text(
                                                                    // '12/12/2024',
                                                                    '${transfer.createdAt.year}/${transfer.createdAt.month.toString().padLeft(2, '0')}/${transfer.createdAt.year.toString().padLeft(2, '0')}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Get.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : const Color(
                                                                              0xFF989898),
                                                                      fontSize:
                                                                          12.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                Container(
                                                                  height: 12.w,
                                                                  decoration:
                                                                      ShapeDecoration(
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          BorderSide(
                                                                        width:
                                                                            0.8.w,
                                                                        strokeAlign:
                                                                            BorderSide.strokeAlignCenter,
                                                                        color: const Color(
                                                                            0xFFAA99C9),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width: 5.w),
                                                                Opacity(
                                                                  opacity: 0.50,
                                                                  child: Text(
                                                                    '${transfer.createdAt.hour}:${transfer.createdAt.minute.toString().padLeft(2, '0')} ${transfer.createdAt.hour > 12 ? 'pm'.tr : 'am'.tr}',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Get.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : const Color(
                                                                              0xFF989898),
                                                                      fontSize:
                                                                          12.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
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
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      SizedBox(
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              transfer.amount
                                                                  .toStringAsFixed(
                                                                      2),
                                                              style: TextStyle(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF222A40),
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                                width: 5),
                                                            Text(
                                                              'sar'.tr,
                                                              style: TextStyle(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : const Color(
                                                                        0xFF222A40),
                                                                fontSize: 13.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ]),
                      ),
                    ),
                  ),
          );
        },
      );
    });
  }
}

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  double textHeight(TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: 'A', style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.height;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375.w,
      height: 268.w,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Get.isDarkMode ? Colors.black : const Color(0xFFF9F9FB),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Get.isDarkMode ? Colors.grey.shade900 : Color(0xFFE7E7E7)),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: -10.h,
            child: SvgPicture.asset(
              'assets/images/wave_shape.svg',
              height: 268.w,
              color: Get.isDarkMode ? Colors.white : null,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'current_balance'.tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  GetBuilder(
                      init: Get.find<ProfileController>(),
                      id: 'wallet',
                      builder: (profile) {
                        if (profile.walletState is Submitting) {
                          return SizedBox(
                              height: textHeight(TextStyle(fontSize: 30.sp)),
                              child: const CupertinoActivityIndicator(
                                color: Colors.black,
                              ));
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              SharedPrefs.instance.wallet?.balance.toStringAsFixed(2) ?? '--',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 9.w),
                            SizedBox(
                              width: 30.w,
                              height: 27.w,
                              child: Text(
                                'sar'.tr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ],
              ),
              SizedBox(height: 19.h),
              // Payment methods
              GetBuilder<ProfileController>(
                init: Get.find<ProfileController>(),
                tag: 'paymentMethods',
                builder: (controller) {
                  if (controller.paymentMethodsState is Submitting) {
                    return Container(
                      height: 36.w,
                      margin: EdgeInsets.all(8.w),
                    );
                  } else if (controller.paymentMethodsState
                      is SubmissionError) {
                    return Text(
                      (controller.paymentMethodsState as SubmissionError)
                          .exception
                          .message,
                    );
                  }

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: controller.paymentMethods!
                        .map(
                          (method) => Container(
                            width: 36.w,
                            height: 36.w,
                            margin: EdgeInsets.all(8.w),
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: method.imageUrl,
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 165.w,
                    child: Container(
                      width: 165.w,
                      height: 48.h,
                      padding: const EdgeInsets.all(4),
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              width: 1.w, color: const Color(0xFFDFE0E5)),
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        alignment: Alignment.center,
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'previous_transactions'.tr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: const Color(0xFF222A40),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 24.w,
                              height: 24.w,
                              padding: const EdgeInsets.only(
                                top: 3,
                                left: 1.71,
                                right: 2,
                                bottom: 3,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(),
                              child:
                                  SvgPicture.asset('assets/icons/history.svg'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SizedBox(
                    width: 165.w,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 165.w,
                          height: 48.h,
                          padding: const EdgeInsets.all(4),
                          decoration: ShapeDecoration(
                            color: const Color(0xFF222A40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: CupertinoButton(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.center,
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    const TransferBalanceDialog(),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'transfer'.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 4),
                                Container(
                                    width: 24.w,
                                    height: 24.w,
                                    padding: EdgeInsets.all(2.w),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: const BoxDecoration(),
                                    child: SvgPicture.asset(
                                        'assets/icons/money.svg')),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
