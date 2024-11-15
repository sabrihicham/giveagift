import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/view/cart/card_preview.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/model/order.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htmltopdf;

import 'package:flutter_native_html_to_pdf/flutter_native_html_to_pdf.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final ProfileController profileController = Get.find<ProfileController>();

  @override
  void initState() {
    profileController.getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('orders'.tr),
        backgroundColor: Colors.transparent,
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          profileController.getOrders();
        },
        child: GetBuilder<ProfileController>(
          init: profileController,
          tag: 'getOrders',
          id: 'getOrders',
          builder: (controller) {
            if (controller.getOrdersState is Submitting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (controller.getOrdersState is SubmissionError) {
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      (controller.getOrdersState as SubmissionError)
                          .exception
                          .message,
                    ),
                    CupertinoButton(
                      onPressed: () {
                        profileController.getOrders();
                      },
                      child: Text('retry'.tr),
                    )
                  ],
                ),
              );
            }

            if (controller.orders == null || controller.orders!.isEmpty) {
              return Center(
                child: Text('no_orders'.tr),
              );
            }

            return SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                children: [
                  for (final order in controller.orders!.reversed)
                    OrderPreview(order: order),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class OrderPreview extends StatelessWidget {
  final Order order;

  const OrderPreview({super.key, required this.order});

  // Order Details

  // Price: 15
  // Shape Price:
  // Color Price: 0
  // celebration Icon Price: 0
  // celebration Link Price: 0
  // VAT Value: 0%
  // Total Price: 15
  // Store: Elct
  // ----------------------
  // Customer & Recipient
  // Customer: hicham sabri
  // Email: hicham@gmail.com
  // Phone Number: 966556855555
  // Recipient: Hicham Sabri
  // Recipient whatsapp: 659668559
  // ----------------------
  // ID & Date
  // Order Number: 46
  // card Id: 66f9663ba63cf14c04b68112
  // Date: 29/09/2024
  // Time: 15:47

  TextStyle get titleStyle => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 22,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'order_data'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          OrderInfoLine(
              text: '${'price'.tr}: ', value: '${order.value} ${'sar'.tr}'),
          OrderInfoLine(
              text: '${'color_price'.tr}: ',
              value: '${order.colorPrice} ${'sar'.tr}'),
          OrderInfoLine(
              text: '${'shape_price'.tr}: ',
              value: '${order.shapesPrice} ${'sar'.tr}'),
          OrderInfoLine(
              text: '${'celebration_shape_price'.tr}: ',
              value: '${order.celebrateIconPrice} ${'sar'.tr}'),
          OrderInfoLine(
              text: '${'celebration_link_price'.tr}: ',
              value: '${order.celebrateQrLinkPrice} ${'sar'.tr}'),
          OrderInfoLine(text: '${'vat'.tr}: ', value: '${order.vat}'),
          OrderInfoLine(
            text: '${'total_price'.tr}: ',
            value: '${order.totalPaid} ${'sar'.tr}',
            isBold: true,
          ),
          // OrderInfoLine(text: '${'store'.tr}: ${order.shop} ${'sar'.tr}'),

          // const Divider(),
          // Text('customer_and_recipient'.tr, style: titleStyle),
          // OrderInfoLine(text: '${'customer'.tr}: ${order.customerName}'),
          // OrderInfoLine(text: '${'email'.tr}: ${order.customerEmail}'),
          // OrderInfoLine(text: '${'phone_number'.tr}: ${order.customerPhone}'),
          // OrderInfoLine(text: '${'receiver_name'.tr}: ${order.recipientName}'),
          // OrderInfoLine(text:'${'receiver_phone_number'.tr}: ${order.recipientWhatsapp}'),

          // const Divider(),
          // Text('id_and_date'.tr, style: titleStyle),
          // OrderInfoLine(text: '${'order_number'.tr}: ${order.orderNumber}'),
          // // OrderInfoLine(text: 'card_id'.tr + ': ${order.cardId}'),
          // OrderInfoLine(text: '${'date'.tr}: ${order.orderDate?.toLocal().day.toString().padLeft(2, "0")}/${order.orderDate?.toLocal().month.toString().padLeft(2, "0")}/${order.orderDate?.toLocal().year}'),
          // OrderInfoLine(text: '${'time'.tr}: ${order.orderDate?.toLocal().hour.toString().padLeft(2, "0")}:${order.orderDate?.toLocal().minute.toString().padLeft(2, "0")}'),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GlobalFilledButton(
                  text: 'view_card'.tr,
                  textSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  width: 132.w,
                  height: 36.h,
                  onPressed: () {
                    showModalBottomSheet(
                        enableDrag: false,
                        constraints: BoxConstraints(
                          // maxHeight: 547.h,
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        backgroundColor: Get.isDarkMode
                            ? Colors.grey.shade900
                            : const Color(0xFFF9F9FB),
                        isScrollControlled: true,
                        context: context,
                        builder: (context) =>
                            CardPreview(cardId: order.cardId!));
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: GlobalFilledButton(
                  text: 'view_invoice'.tr,
                  textColor: Theme.of(context).colorScheme.secondary,
                  textSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  width: 132.w,
                  height: 36.h,
                  color: const Color.fromRGBO(249, 249, 251, 1),
                  onPressed: () async {
                    OverlayUtils.showLoadingOverlay(asyncFunction: () async {
                      final directory = await getTemporaryDirectory();

                      final tempFile = File(
                          directory.path + '/' + basename(order.id! + '.pdf'));

                      final isLTR = Get.locale?.languageCode == 'ar';

                      final htmlContent = '''
                      <html ${isLTR ? 'dir="rtl"' : ''}>
                        <head>
                            <meta charset="UTF-8">
                            <meta name="viewport" content="width=device-width, initial-scale=1.0"> 

                            <title>Order PDF Content</title>
                            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.3.1/dist/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
                            <link href="https://fonts.googleapis.com/css?family=Cairo" rel="stylesheet">
                            <style>
                                body {
                                  font-family: 'Cairo', sans-serif;
                                }

                                .header_details {
                                    display: flex;
                                    justify-content: center;
                                    align-items: center;
                                    text-align: center;
                                    flex-direction: column;
                                    font-family: "Cairo", sans-serif;
                                }

                                .min_width_fixed {
                                    min-width: 700px;
                                }

                                .qr_code_img {
                                    width: 150px;
                                    margin: auto;
                                }

                                .order_ul {
                                    padding: 0;
                                    margin: 0;
                                    width: 75%;
                                    margin: auto;
                                }

                                .order_ul li {
                                    font-size: 18px;
                                    border-bottom: 1px solid rgba(0, 0, 0, 0.244);
                                    display: flex;
                                    justify-content: space-between;
                                    padding: 10px;
                                    font-weight: 600;
                                    color: #818181;
                                }

                                .order_ul li span {
                                    font-weight: 700;
                                }

                                .item_header {
                                    font-size: 22px !important;
                                    font-weight: 600 !important;
                                    border-top: 1px solid rgba(0, 0, 0, 0.244);
                                    color: rgba(0, 0, 0, 1) !important;
                                }
                            </style>
                        </head>
                        <body>
                            <div class="header_details min_width_fixed">
                                <p  class="m-0 fw-bold text-secondary">
                                    ${'order_number'.tr} (${order.orderNumber ?? ''})
                                </p>
                                <h4 class="text-center my-3">
                                    شركة أعط الهدية للتجارة والتسويق
                                </h4>
                                <h4 class="text-center text-secondaryr mb-5" >الرياض</h4>
                            </div>
                            <div class="min_width_fixed">
                                <div class="my-4 w-75 mb-5 order_ul" ${isLTR ? 'style="text-align: right;' : ''}">
                                    <p> ${'date'.tr}: ${order.orderDate?.year}/${order.orderDate?.month.toString().padLeft(2, '0')}/${order.orderDate?.day.toString().padLeft(2, '0')}</p>
                                    <p> ${'time'.tr}: ${order.orderDate?.hour.toString().padLeft(2, '0')}/${order.orderDate?.minute.toString().padLeft(2, '0')}</p>
                                    <p> ${'shop'.tr}: ${order.shop}</p>
                                    <p> ${'tax_number'.tr}: </p>
                                </div>
                                <ul class="order_ul">
                                    <li class="item_header">
                                        <span>${'categories'.tr}</span> ${'price'.tr}
                                    </li>
                                    ${order.value == null || order.value! <= 0 ? '' : '''
                                        <li style="color: #6c757d;">
                                            <span style>${'card_price'.tr}</span> ${order.value} ${'sar.'.tr}
                                        </li>
                                        '''}
                                    ${order.shapesPrice == null || order.shapesPrice! <= 0 ? '' : '''
                                        <li style="color: #6c757d;">
                                            <span style>${'shape_price'.tr}</span> ${order.shapesPrice} ${'sar.'.tr}
                                        </li>
                                        '''}
                                    ${order.colorPrice == null || order.colorPrice! <= 0 ? '' : '''
                                        <li style="color: #6c757d;">
                                            <span>${'color_price'.tr}</span> ${order.colorPrice ?? ''} ${'sar.'.tr}
                                        </li>
                                        '''}
                                    ${order.celebrateIconPrice == null || order.celebrateIconPrice! <= 0 ? '' : '''
                                        <li style="color: #6c757d;">
                                          <span>${'celebration_shape_price'.tr}</span> ${order.celebrateIconPrice ?? ''} ${'sar.'.tr}
                                        </li>
                                      '''}
                                    ${order.celebrateQrLinkPrice == null || order.celebrateQrLinkPrice! <= 0 ? '' : '''
                                        <li style="color: #6c757d;">
                                            <span>${'celebration_link_price'.tr}</span> ${order.celebrateQrLinkPrice ?? ''} ${'sar.'.tr}
                                        </li>
                                        '''}
                                    <li style="color: #6c757d;">
                                        <span>${'vat'.tr}</span> ${order.vat}
                                    </li>
                                    <li style="color: #6c757d;">
                                        <span>${'total_price'.tr}</span> ${order.totalPaid} ${'sar.'.tr}
                                    </li>
                                    </ul>
                                <div class="qr_code_img">
                                    <img class="w-100" src="data:image/png;base64,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" alt="qrCode">
                                </div>
                            </div>
                        </body>
                        </html>
                        ''';

                      final newpdf = htmltopdf.Document();

                      List<htmltopdf.Widget> widgets =
                          await htmltopdf.HTMLToPdf()
                              .convert(htmlContent, defaultFontFamily: 'Cairo');

                      newpdf.addPage(htmltopdf.MultiPage(
                          maxPages: 200,
                          crossAxisAlignment:
                              htmltopdf.CrossAxisAlignment.center,
                          mainAxisAlignment: htmltopdf.MainAxisAlignment.center,
                          build: (context) {
                            return widgets;
                          }));

                      // await tempFile.writeAsBytes(await newpdf.save());

                      final _flutterNativeHtmlToPdfPlugin =
                          FlutterNativeHtmlToPdf();

                      Directory appDocDir =
                          await getApplicationDocumentsDirectory();
                      final targetPath = appDocDir.path;
                      const targetFileName = "mytext";
                      final generatedPdfFile =
                          await _flutterNativeHtmlToPdfPlugin.convertHtmlToPdf(
                        html: htmlContent,
                        targetDirectory: targetPath,
                        targetName: targetFileName,
                      );

                      // generatedPdfFilePath = generatedPdfFile?.path;

                      Get.to(() => PdfViewer(filePath: generatedPdfFile!.path));
                      // newpdf.save().then((bytes) {
                      // });
                    });
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class OrderInfoLine extends StatelessWidget {
  const OrderInfoLine(
      {super.key,
      required this.text,
      required this.value,
      this.isBold = false});

  final String text, value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            'assets/icons/dollar.svg',
            color: Theme.of(context).primaryColor,
            width: 22,
            height: 22,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isBold ? FontWeight.w700 : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String filePath;

  const PdfViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Share.shareXFiles([XFile(filePath)]);
              },
              icon: const Icon(Icons.share),
            )
          ],
          title: Text('view_invoice'.tr),
        ),
        body: Container(
            child: SfPdfViewer.file(
          File(filePath),
        )));
  }
}
