import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/celebrate.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/extensions/web_images.dart';
import 'package:giveagift/view/cards/widgets/brand_image.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:giveagift/view/widgets/global_section_header.dart';
import 'package:giveagift/view/widgets/my_flip_card.dart';

class CardPreview extends StatefulWidget {
  final String cardId;

  const CardPreview({super.key, required this.cardId});

  @override
  State<CardPreview> createState() => _CardPreviewState();
}

class _CardPreviewState extends State<CardPreview> {
  final cartController = Get.find<CartController>();
  Color iconsColor = const Color.fromRGBO(106, 126, 140, 1);
  Card? card;
  DateTime? receiveAt;

  int selectedIndex = 0;

  FlipCardController flipController = FlipCardController();

  bool get isFront => flipController.state?.isFront ?? true;

  @override
  void initState() {
    cartController.getCard(widget.cardId).then((value) {
      if (value == null) {
        return;
      }

      card = value;

      if (card!.isDelivered == true) {
        receiveAt = card!.receiveAt;
      }

      cartController.getCardSetState(const SubmissionSuccess());

      if (card?.isPaid == true && card?.celebrateIcon != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            Celebrate.instance.celebrate(
              context,
              celebrateTypeFromString(card!.celebrateIcon!),
              MediaQuery.of(context).size.width > 600,
            );
          },
        );
      }
    });

    super.initState();
  }

  String _formatDate(DateTime date) {
    return "${date.year}/${date.month}/${date.day}";
  }

  String _formatHour(DateTime time) {
    return "${time.hour}:${time.minute}";
  }

  Widget _buildCardPreviewDetails() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: MyFlipCard(
            controller: flipController,
            card: card!,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 9),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: BrandImage(
                  logoImage: card!.shop!.logo.shopImage,
                  backgroundColor: Colors.white,
                  onTap: () {
                    card!.shop!.launchShop();
                  },
                  fit: BoxFit.fill,
                  margin: EdgeInsets.zero,
                  size: 60.w,
                ),
              ),
              // Price
              Text(
                '${card!.price?.value ?? '-'} ${'sar'.tr}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              if(!isFront)
                if(card!.celebrateQR != null)
                  Image.memory(
                    base64Decode(card!.celebrateQR!.split(',').last),
                    width: 100.w,
                    height: 100.w,
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'for_you'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      FaIcon(
                        FontAwesomeIcons.gift,
                        color: Colors.amber,
                        size: 20.sp,
                      )
                    ],
                  )
              else
                if(card!.discountCode?.qrCode != null)
                  Image.memory(
                    base64Decode(card!.discountCode!.qrCode!.split(',').last),
                    width: 100.w,
                    height: 100.w,
                  )
                else if(card!.discountCode?.code != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SelectableText(
                        card!.discountCode!.code!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 5.w),
                      FaIcon(
                        FontAwesomeIcons.gift,
                        color: Colors.amber,
                        size: 20.sp,
                      )
                    ],
                  ),
              SizedBox(
                height: 9.h,
              ),
              if (card?.isPaid == true)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SvgPicture.asset(
                    //       'assets/icons/gift.svg',
                    //       width: 20,
                    //       height: 20,
                    //       color: ConstColors.gold
                    //     ),
                    //     const SizedBox(width: 10),
                    //     Text(
                    //       card!.id,
                    //       style: const TextStyle(
                    //         fontSize: 16,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        card!.discountCode?.isUsed == true
                            ? 'card_used'.tr
                            : 'card_ready'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: card!.discountCode?.isUsed == true
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(9),
                          child: SvgPicture.asset(
                            'assets/icons/date.svg',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          receiveAt == null
                              ? _formatDate(DateTime.now())
                              : _formatDate(receiveAt!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(9),
                          child: SvgPicture.asset(
                            'assets/icons/time.svg',
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          receiveAt == null
                              ? 'now'.tr
                              : _formatHour(receiveAt!),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      init: cartController,
      id: 'getCard',
      builder: (controller) {
        if (controller.getCardState is Submitting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        } else if (controller.getCardState is SubmissionError) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (controller.getCardState as SubmissionError)
                      .exception
                      .message,
                ),
                CupertinoButton(
                  onPressed: () {
                    cartController.getCard(widget.cardId);
                  },
                  child: Text('retry'.tr),
                )
              ],
            ),
          );
        }
        return Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width > 600 ? 500 : 440,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                  decoration: BoxDecoration(
                    // color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Get.isDarkMode
                    //         ? Colors.grey.shade900
                    //         : Colors.grey.shade200,
                    //     blurRadius: 5,
                    //   ),
                    // ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          Text(
                            'card_preview'.tr,
                            style: TextStyle(
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.secondary,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.close,
                              color: iconsColor,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 107.w,
                              height: 36.h,
                              decoration: ShapeDecoration(
                                color: selectedIndex == 0
                                    ? const Color(0xFF222A40)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  if (selectedIndex == 0) {
                                    // setState(() {});
                                    return;
                                  }

                                  if (!isFront) {
                                    flipController.flipcard();
                                  }

                                  setState(() => selectedIndex = 0);
                                },
                                padding: EdgeInsets.zero,
                                child: Center(
                                  child: Text(
                                    'card'.tr,
                                    style: TextStyle(
                                      color: selectedIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 107.w,
                              height: 36.h,
                              decoration: ShapeDecoration(
                                color: selectedIndex == 1
                                    ? const Color(0xFF222A40)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: CupertinoButton(
                                onPressed: () {
                                  if (selectedIndex == 1) {
                                    // setState(() {});
                                    return;
                                  }

                                  if (isFront) {
                                    flipController.flipcard();
                                  }

                                  setState(() => selectedIndex = 1);
                                },
                                padding: EdgeInsets.zero,
                                child: Center(
                                  child: Text(
                                    'from_behind'.tr,
                                    style: TextStyle(
                                      color: selectedIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 107.w,
                              height: 36.h,
                              decoration: ShapeDecoration(
                                color: selectedIndex == 2
                                    ? const Color(0xFF222A40)
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              child: CupertinoButton(
                                onPressed: () =>
                                    setState(() => selectedIndex = 2),
                                padding: EdgeInsets.zero,
                                child: Center(
                                  child: Text(
                                    'how_to_use'.tr,
                                    style: TextStyle(
                                      color: selectedIndex == 2
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            // Expanded(
                            //   child: Text(
                            //     'how_to_use'.tr,
                            //     style: const TextStyle(
                            //       fontSize: 20,
                            //       fontWeight: FontWeight.w600,
                            //     ),
                            //   ),
                            // ),
                            // IconButton(
                            //   onPressed: () {
                            //     Get.dialog(
                            //       AlertDialog(
                            //         title: Text('how_to_use'.tr),
                            //         content: Column(
                            //             mainAxisSize: MainAxisSize.min,
                            //             children: [
                            //               // Go to the Store website through Link here
                            //               // Copy the promo Code
                            //               // Paste the code in the designated input field
                            //               // Get your discount From Store
                            //               for (var i = 1; i <= 4; i++)
                            //                 Row(
                            //                   children: [
                            //                     const Icon(
                            //                       Icons.circle,
                            //                       color: Colors.green,
                            //                       size: 15,
                            //                     ),
                            //                     const SizedBox(width: 10),
                            //                     Text(
                            //                       'step_$i'.tr,
                            //                       style: const TextStyle(
                            //                         fontSize: 18,
                            //                         fontWeight: FontWeight.w600,
                            //                       ),
                            //                     ),
                            //                     if (i == 1)
                            //                       InkWell(
                            //                         onTap: () => card?.shop?.launchShop(),
                            //                         child: RichText(
                            //                           text: TextSpan(
                            //                             text: '  ',
                            //                             children: [
                            //                               TextSpan(
                            //                                 text: 'here'.tr,
                            //                                 style: const TextStyle(
                            //                                   color: Colors.blue,
                            //                                   decoration: TextDecoration.underline,
                            //                                 ),
                            //                               ),
                            //                             ],
                            //                           ),
                            //                         ),
                            //                       ),
                            //                   ],
                            //                 )
                            //             ]
                            //           ),
                            //         actions: [
                            //           TextButton(
                            //             onPressed: () {
                            //               Get.back();
                            //             },
                            //             child: Text('close'.tr),
                            //           ),
                            //         ],
                            //       ),
                            //     );
                            //   },
                            //   icon: Icon(
                            //     Icons.help,
                            //     color: iconsColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      IndexedStack(
                        index: selectedIndex == 1
                            ? 0
                            : selectedIndex == 2
                                ? 1
                                : 0,
                        children: [
                          _buildCardPreviewDetails(),
                          OutlineContainer(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.r)),
                            color: Get.isDarkMode
                                ? Colors.grey[800]
                                : Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GlobalSectionHeader(title: 'follow_instructions'.tr),
                                const SizedBox(height: 13),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.square,
                                        color: Colors.black,
                                        size: 5,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${'instruction_1'.tr} ',
                                              style: TextStyle(
                                                color: Get.isDarkMode ? Colors.white : const Color(0xFF222A40),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'here'.tr,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  card?.shop?.launchShop();
                                                },
                                              style: TextStyle(
                                                color: Get.isDarkMode ? Colors.white : const Color(0xFF222A40),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                decoration: TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.square,
                                        color: Colors.black,
                                        size: 5,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'instruction_2'.tr,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF222A40),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.square,
                                        color: Colors.black,
                                        size: 5,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'instruction_3'.tr,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF222A40),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.square,
                                        color: Colors.black,
                                        size: 5,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'instruction_4'.tr,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Get.isDarkMode ? Colors.white : const Color(0xFF222A40),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
