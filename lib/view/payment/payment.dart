import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/cart/model/execute_payment.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/model/paymrnt_method.dart';

import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/view/webview.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:giveagift/view/widgets/my_flip_card.dart';
import 'package:pay_ios/pay_ios.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    this.card,
    this.amount,
    required this.type,
  });

  final Card? card;
  final num? amount;
  final PaymentType type;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final controller = Get.find<ProfileController>();
  final message = ValueNotifier<String>('');
  final TextEditingController amountController = TextEditingController();
  final selectedMethod = ValueNotifier<PaymentMethod?>(null);

  @override
  void initState() {
    controller.getPaymentMethods();
    super.initState();
  }

  _onSubmit() async {
    if (selectedMethod.value == null) {
      message.value = 'unselected_payment_msg'.tr;
      return;
    } else if (widget.type == PaymentType.DEPOSIT && amountController.text.isEmpty) {
      message.value = 'enter_amount_msg'.tr;
      return;
    } else {
      message.value = '';
    }

    if (Platform.isIOS || Platform.isAndroid) {
      String successUrl = "${API.BASE_URL}/payment-success/${widget.card?.id}";
      String errorUrl = "${API.BASE_URL}/payment-faild";
      final response = await client.post(
        Uri.parse("${API.BASE_URL}/api/v1/payments/execute-payment"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          ExecutePaymentRequest(
            paymentMethodId: selectedMethod.value!.paymentMethodId,
            invoiceValue: widget.type == PaymentType.DEPOSIT
              ? num.parse(amountController.text).toDouble()
              : widget.card?.totalWithVat.toDouble(),
            cardId: widget.card?.id,
            type: widget.type,
            errorURL: errorUrl,
            successURL: successUrl,
          ).toJson(),
        ),
      );

      if (response.statusCode < 500) {
        final paymentResponse = ExecutePaymentResponse.fromJson(json.decode(response.body));

        if (paymentResponse.isSuccess) {
          final executePayment = paymentResponse.data;

          // bool isSuccess = await launchUrlString(
          //   executePayment!.data.paymentURL,
          //   mode: LaunchMode.externalApplication,
          // );

          dynamic isSuccess;

          // if (selectedMethod.value?.paymentMethodId == 11) {

          //   await launchUrlString(
          //     executePayment!.data.paymentURL,
          //     mode: LaunchMode.externalApplication,
          //   );

          // } else {
            isSuccess = await Get.to(
              () => InAppWebViewPage(
                arguments: WebViewArguments(
                  url: executePayment!.data.paymentURL,
                  successUrl: successUrl,
                  errorUrl: errorUrl,
                  title: "payment".tr,
                ),
              ),
            );
          // }

          // isSuccess = await Get.to(
          //   () => InAppWebViewPage(
          //     arguments: WebViewArguments(
          //       url: executePayment!.data.paymentURL,
          //       successUrl: successUrl,
          //       errorUrl: errorUrl,
          //       title: "payment".tr,
          //     ),
          //   ),
          // );

          if (isSuccess == true) {
            Get.snackbar(
              'success'.tr,
              'payment_success_message'.tr,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            Navigator.of(context).pop(true);
          } else {
            Get.snackbar(
              'error'.tr,
              'payment_failed_message'.tr,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          Get.snackbar(
            'error'.tr,
            paymentResponse.message ?? 'Error occurred while processing payment',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'error'.tr,
          'server_error_message'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ask for name, email, phone number
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? null : Colors.transparent,
        title: Text('payment'.tr),
      ),
      body: SafeArea(
        child: GetBuilder(
            init: controller,
            tag: 'paymentMethods',
            builder: (controller) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.card != null)
                                  Column(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        child: MyFlipCard(card: widget.card!)
                                      ),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'select_payment_method'.tr,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                GetBuilder(
                                  init: controller,
                                  id: 'paymentMethods',
                                  builder: (profileController) {
                                    return ValueListenableBuilder(
                                      valueListenable: selectedMethod,
                                      builder: (context, method, child) => OutlineContainer(
                                        color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                        child: DropdownButton<PaymentMethod>(
                                          value: method,
                                          isExpanded: true,
                                          underline: const SizedBox.shrink(),
                                          enableFeedback: true,
                                          dropdownColor: Get.isDarkMode
                                            ? Colors.grey.shade900
                                            : Colors.white,
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                            size: 26,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                          hint: Text('select_payment_method'.tr),
                                          onChanged: (value) {
                                            selectedMethod.value = value;
                                          },
                                          items: [
                                            if(controller.paymentMethodsState is Submitting)
                                              const DropdownMenuItem(
                                                enabled: false,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    CupertinoActivityIndicator()
                                                  ],
                                                )
                                              ),
                                            if(controller.paymentMethodsState is SubmissionError)
                                              DropdownMenuItem(
                                                onTap: ( ) {
                                                  profileController.getPaymentMethods();
                                                },
                                                child: Text(
                                                  'retry'.tr,
                                                  textAlign: TextAlign.center,
                                                )
                                              ),
                                            if(controller.paymentMethodsState is SubmissionSuccess)
                                              ...controller.paymentMethods!
                                              .where((element) => Platform.isIOS || Platform.isAndroid && element.paymentMethodId != 11)
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        imageUrl: e.imageUrl,
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                      const SizedBox(width: 10),
                                                      Text(
                                                        Get.locale?.languageCode == "ar"
                                                            ? e.paymentMethodAr
                                                            : e.paymentMethodEn,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ]
                                        ),
                                      ),
                                    );
                                  }
                                ),
                                // GridView.builder(
                                //   gridDelegate:
                                //       const SliverGridDelegateWithFixedCrossAxisCount(
                                //     crossAxisCount: 3,
                                //     // childAspectRatio: 1,
                                //     crossAxisSpacing: 10,
                                //     mainAxisSpacing: 10,
                                //   ),
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   shrinkWrap: true,
                                //   itemCount: controller.paymentMethods!.length,
                                //   itemBuilder: (context, index) {
                                //     final paymentMethod =
                                //         controller.paymentMethods![index];
                                //     return GestureDetector(
                                //       onTap: () {
                                //         setState(() {
                                //           selectedMethod = paymentMethod;
                                //         });
                                //       },
                                //       child: Badge(
                                //         largeSize: 24,
                                //         label: selectedMethod == paymentMethod
                                //             ? Icon(
                                //                 Icons.check_circle,
                                //                 color: Colors.blue,
                                //               )
                                //             : null,
                                //         backgroundColor: Colors.transparent,
                                //         child: Container(
                                //           margin: const EdgeInsets.symmetric(
                                //               horizontal: 10, vertical: 10),
                                //           padding: const EdgeInsets.all(10),
                                //           decoration: BoxDecoration(
                                //             border: Border.all(
                                //               color: selectedMethod == paymentMethod
                                //                   ? Colors.blue
                                //                   : Colors.grey,
                                //               width: 2,
                                //             ),
                                //             borderRadius: BorderRadius.circular(10),
                                //           ),
                                //           child: Column(
                                //             children: [
                                //               Padding(
                                //                 padding: const EdgeInsets.all(8.0),
                                //                 child: CachedNetworkImage(
                                //                     imageUrl: paymentMethod.imageUrl),
                                //               ),
                                //               Text(
                                //                 Get.locale?.languageCode == "ar"
                                //                     ? paymentMethod.paymentMethodAr
                                //                     : paymentMethod.paymentMethodEn,
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                                // amount text feild only numbers
                                if (widget.type == PaymentType.PAYMENT)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: TicketWidget(
                                        title: 'summary'.tr,
                                        color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                        children: [
                                          TicketRow(
                                            info: 'card_price'.tr,
                                            value: '${widget.card?.price!.value} ${'sar'.tr}',
                                          ),
                                          const SizedBox(height: 10),
                                          if (widget.card?.proColor != null)
                                            Column(
                                              children: [
                                                TicketRow(
                                                  info: 'color_price'.tr,
                                                  value: '${widget.card?.proColor?.price.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          if (widget.card?.shapes != null && widget.card!.shapes!.any((element) => element.shape.price != null))
                                            Column(
                                              children: [
                                                TicketRow(
                                                  info: 'shape_price'.tr,
                                                  value: '${widget.card?.shapes!.fold(0.0, (prev, value) => prev + (value.shape.price ?? 0)).toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          if (widget.card?.celebrateIcon != null)
                                            Column(
                                              children: [
                                                TicketRow(
                                                  info: 'celebration_shape'.tr,
                                                  value: '${SharedPrefs.instance.appConfig?.celebrateIconPrice?.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          if (widget.card?.celebrateQR != null)
                                            Column(
                                              children: [
                                                TicketRow(
                                                  // '${'celebration_link'.tr}: ${SharedPrefs.instance.appConfig?.celebrateIconPrice.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                                                  info: 'celebration_link'.tr,
                                                  value: '${SharedPrefs.instance.appConfig?.celebrateLinkPrice?.toStringAsFixed(2) ?? '-'} ${'sar'.tr}',
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          TicketRow(
                                            info: '${'vat'.tr} (${SharedPrefs.instance.appConfig?.vatValue}%)',
                                            value: '${widget.card?.vat} ${'sar'.tr}',
                                          ),
                                          const SizedBox(height: 10),
                                          TicketRow(
                                            info: 'amount'.tr,
                                            value: '${widget.card?.totalWithVat} ${'sar'.tr}',
                                          ),
                                        ]),
                                  ),
                                if (widget.type == PaymentType.DEPOSIT)
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          '${'amount'.tr} (${"sar".tr})',
                                          textAlign: TextAlign.start,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TapRegion(
                                        onTapOutside: (event) {
                                          FocusScope.of(context).unfocus();
                                        },
                                        child: TextField(
                                          controller: amountController,
                                          keyboardType: const TextInputType.numberWithOptions(
                                            decimal: true,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,
                                          ],
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                // error message
                                ValueListenableBuilder<String>(
                                  valueListenable: message,
                                  builder: (context, value, child) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: selectedMethod,
                          builder: (context, method, child) => SafeArea(
                            top: false,
                            child: method?.paymentMethodId == 11
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        // horizontal: 10,
                                        // vertical: 10,
                                        ),
                                    width: double.infinity,
                                    height: 52.h,
                                    child: RawApplePayButton(
                                      cornerRadius: 8,
                                      style: Get.isDarkMode
                                          ? ApplePayButtonStyle.white
                                          : ApplePayButtonStyle.black,
                                      type: ApplePayButtonType.plain,
                                      onPressed: _onSubmit,
                                    ),
                                  )
                                : GlobalFilledButton(
                                    // padding: const EdgeInsets.symmetric(horizontal: 10),
                                    height: 52.h,
                                    width: double.infinity,
                                    text: 'pay'.tr,
                                    onPressed: _onSubmit,
                                    // CupertinoButton(
                                    //   padding: EdgeInsets.zero,
                                    //   onPressed: _onSubmit,
                                    //   child: Text(

                                    //     style: const TextStyle(
                                    //       color: Colors.white,
                                    //       fontSize: 20,
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class TicketRow extends StatelessWidget {
  const TicketRow({super.key, required this.info, required this.value});

  final String info, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          info,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class TicketWidget extends StatelessWidget {
  TicketWidget({
    super.key,
    this.title,
    this.children,
    this.color,
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    ),
  });

  final String? title;
  final List<Widget>? children;
  final Radius radius = const Radius.circular(20);
  final Color borderColor = Colors.grey[350]!;
  final EdgeInsets contentPadding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(color: borderColor);
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: contentPadding.copyWith(bottom: 0),
          decoration: BoxDecoration(
            color: color,
            border: Border(
              top: borderSide,
              left: borderSide,
              right: borderSide,
            ),
            borderRadius: BorderRadius.only(
              topLeft: radius,
              topRight: radius,
            ),
          ),
          child: Text(
            title ?? '',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Line
        Container(
          width: double.infinity,
          color: color,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              children: [
                // Circle
                Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: borderSide,
                      right: borderSide,
                      bottom: borderSide,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: radius,
                      bottomRight: radius,
                    ),
                  ),
                ),
                // dotted line
                Expanded(
                  child: CustomPaint(
                    size: const Size(
                      double.infinity,
                      20,
                    ), // Adjust size as needed
                    painter: DottedLine(
                      color: borderColor,
                    ),
                  ),
                ),
                // Circle
                Container(
                  width: 10,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    border: Border(
                      top: borderSide,
                      left: borderSide,
                      bottom: borderSide,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: radius,
                      bottomLeft: radius,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Content
        Container(
          width: double.infinity,
          padding: contentPadding,
          decoration: BoxDecoration(
            color: color,
            border: Border(
              left: borderSide,
              right: borderSide,
            ),
            borderRadius: const BorderRadius.only(
                // bottomLeft: radius,
                // bottomRight: radius,
                ),
          ),
          child: Column(
            children: children ?? [],
          ),
        ),
        // Botttom circles
        Container(
            width: double.infinity,
            padding: contentPadding.copyWith(bottom: 0),
            decoration: BoxDecoration(
              color: color,
              border: Border(
                bottom: borderSide,
                left: borderSide,
                right: borderSide,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: radius,
                bottomRight: radius,
              ),
            )),
        // Container(
        //   width: double.infinity,
        //   height: 20,
        //   clipBehavior: Clip.antiAlias,
        //   decoration: BoxDecoration(),
        //   child: CustomPaint(
        //     size: const Size(
        //       double.infinity,
        //       20,
        //     ), // Adjust size as needed
        //     painter: MyPainter(
        //       color: borderColor,
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class DottedLine extends CustomPainter {
  final Color color;

  DottedLine({this.color = Colors.grey});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      // Or any color you prefer
      ..strokeWidth = 1 // Adjust thickness as needed
      ..style = PaintingStyle.stroke;

    final double dashWidth = 5;
    final double dashSpace = 5;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(startX + dashWidth, size.height / 2),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MyPainter extends CustomPainter {
  final Color color;

  MyPainter({this.color = Colors.blue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      // Or any color you prefer
      ..strokeWidth = 1 // Adjust thickness as needed
      ..style = PaintingStyle.stroke;

    double circleWidth = 18;
    double spaceBetween = 10;

    if (size.width < circleWidth) {
      circleWidth = size.width;
    }

    // should end with circle
    while ((size.width - circleWidth) % (circleWidth + spaceBetween) >
        circleWidth) {
      circleWidth -= 0.1;
    }

    // Create the repeated half circles between them 5 px lines
    for (int i = 0; i < size.width / (circleWidth + spaceBetween); i++) {
      canvas.drawArc(
        Rect.fromCircle(
          center: Offset(i * (circleWidth + spaceBetween), circleWidth / 2),
          radius: circleWidth / 2,
        ),
        // draw pi/2 the first one
        i == 0 ? -pi / 2 : 0,
        i == 0 ? pi / 2 : -pi,
        false,
        paint,
      );

      // Draw betzween gabs
      canvas.drawLine(
        Offset(
          i * (circleWidth + spaceBetween) + circleWidth / 2,
          circleWidth / 2,
        ),
        Offset(
          (i + 1) * (circleWidth + spaceBetween) - circleWidth / 2,
          circleWidth / 2,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class OutlineContainer extends StatelessWidget {
  const OutlineContainer({
    super.key,
    this.title,
    this.titleSize,
    this.child,
    this.width,
    this.height,
    this.color,
    this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.padding = const EdgeInsets.all(10),
    this.margin = EdgeInsets.zero,
  });

  final String? title;
  final double? titleSize;
  final double? width, height;
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  title!,
                  style: Get.textTheme.headlineSmall?.copyWith(fontSize: titleSize),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        Container(
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor ?? Colors.grey[350]!,
            ),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ],
    );
  }
}
