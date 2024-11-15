import 'package:flutter/material.dart' hide Card;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/constants/enums.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/dialog_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cards/data/models/ready_card.dart';
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/cart/card_preview.dart';
import 'package:giveagift/view/cart/cart.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/recepient_info.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:giveagift/view/profile/terms_and_conditions.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:giveagift/view/widgets/my_flip_card.dart';

class ReadyCardPreview extends StatefulWidget {
  final CardData card;
  final String shopId;

  const ReadyCardPreview({super.key, required this.card, required this.shopId});

  @override
  State<ReadyCardPreview> createState() => _ReadyCardPreviewState();
}

class _ReadyCardPreviewState extends State<ReadyCardPreview> {
  final cartController = Get.find<CartController>();
  Color iconsColor = const Color.fromRGBO(106, 126, 140, 1);
  DateTime? receiveAt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? null : Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'card_preview'.tr,
          style: TextStyle(
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        // backgroundColor: Colors.transparent,
        actions: [],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width > 600 ? 500 : 440,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10).copyWith(
                      // App bar
                      top: 80 + MediaQuery.of(context).padding.top,
                      bottom: MediaQuery.of(context).size.height <
                              MediaQuery.of(context).size.width
                          ? 100
                          : null),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Get.isDarkMode
                                  ? Colors.grey.shade900
                                  : Colors.grey.shade200,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyFlipCard(
                              card: widget.card.toCard(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'card_details'.tr,
                          style: TextStyle(
                              color:
                                  Get.isDarkMode ? Colors.white : Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 10),
                      OutlineContainer(
                        // color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'description'.tr,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                child: Text(
                                  widget.card.shop?.description ?? '-',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      OutlineContainer(
                        title: 'card_info'.tr,
                        titleSize: 20,
                        child: Column(
                          children: [
                            GlobalListTile(
                              title: 'available_until'.tr,
                              endWidget: Text(DateUtils.dateFormater(
                                  DateTime.now().add(100.days))),
                              leading: GlobalIcon(
                                assetPath: 'assets/icons/date.svg',
                              ),
                            ),
                            // ListTile(
                            //   title: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text('available_until'.tr,
                            //         style: TextStyle(
                            //           fontSize: 18,
                            //           color: Get.isDarkMode
                            //             ? const Color.fromRGBO(238, 238, 238, 1)
                            //             : Colors.grey[800]),
                            //       ),
                            //       Text(DateUtils.dateFormater(DateTime.now().add(100.days)))
                            //     ],
                            //   ),
                            //   leading: Container(
                            //     padding: EdgeInsets.all(5),
                            //     decoration: BoxDecoration(
                            //         color: Theme.of(context).colorScheme.secondary,
                            //         borderRadius: BorderRadius.circular(10)),
                            //     child: Icon(
                            //       Icons.date_range_rounded,
                            //       color: Theme.of(context).primaryColor,
                            //     ),
                            //   ),
                            // ),
                            GlobalListTile(
                              title: 'card_valid'.tr,
                              endWidget: Text('100 ${'day'.tr}'),
                              leading: const GlobalIcon(
                                assetPath: 'assets/icons/time.svg',
                              ),
                            ),
                            GlobalListTile(
                                title: 'terms_and_conditions'.tr,
                                click: true,
                                onTap: () => Get.to(() => const TermsAndConditionsPage()),
                                leading: const GlobalIcon(
                                  assetPath: 'assets/icons/secure-signin.svg',
                                  iconSize: 18,
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    child: GlobalFilledButton(
                      // lable: 'buy'.tr,
                      height: 52.h,
                      text: 'buy'.tr,
                      onPressed: () async {
                        cartController.addSpecialCardToCartView(widget.shopId, widget.card, context);
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class GlobalListTile extends StatelessWidget {
  final void Function()? onTap;
  final String? title;
  final Widget? startWidget;
  final Widget? endWidget;
  final Widget? leading;
  final bool click;
  final double? minVerticalPadding;
  final Color? titleColor, clickColor;

  const GlobalListTile(
      {super.key,
      this.onTap,
      this.title,
      this.startWidget,
      this.endWidget,
      this.leading,
      this.click = false,
      this.minVerticalPadding,
      this.titleColor,
      this.clickColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 28..h,
      child: ListTile(
          onTap: onTap,
          minVerticalPadding: minVerticalPadding,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              startWidget ??
              Text(
                title ?? '-',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: titleColor ?? (Get.isDarkMode ? Colors.grey[200] : Colors.grey[800])
                  )
                ),
              endWidget ?? const SizedBox.shrink()
            ],
          ),
          trailing: click
              ? Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: clickColor,
                )
              : null,
          leading: leading
        ),
    );
  }
}

class GlobalIcon extends StatelessWidget {
  final String assetPath;
  final Color? color;
  final double? iconSize;
  final EdgeInsets? padding;
  final Widget? title;

  const GlobalIcon(
      {super.key,
      required this.assetPath,
      this.color,
      this.padding = const EdgeInsets.all(5),
      this.iconSize,
      this.title});

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color?.withOpacity(0.0) ?? Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: SvgPicture.asset(
        assetPath,
        color: color ?? Theme.of(context).primaryColor,
        fit: BoxFit.fill,
        width: iconSize,
        height: iconSize,
      ),
    );

    return title != null
      ? Column(
        children: [content, const SizedBox(height: 5), title!],
      )
      : content;
  }
}

class DateUtils {
  static String dateFormater(DateTime date) {
    return '${("month_${date.month}").tr} ${date.year},${date.day}';
  }
}
