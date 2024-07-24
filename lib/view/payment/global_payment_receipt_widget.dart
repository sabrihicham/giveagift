// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/MFModels.dart';

class GlobalPaymentReceiptWidget extends StatelessWidget {
  final MFGetPaymentStatusResponse? invoiceStatus;
  final bool showMycoursesButton;
  const GlobalPaymentReceiptWidget({
    super.key,
    this.invoiceStatus,
    this.showMycoursesButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xffF4F6FB),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  color: Colors.black.withOpacity(
                    0.25,
                  ),
                )
              ],
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: _buildSingleDetailsItem(
                          leading: "Invoice ID",
                          title: invoiceStatus?.invoiceId.toString(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.print,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildSingleDetailsItem(
                    leading: "Invoice Reference",
                    title: invoiceStatus?.invoiceReference,
                  ),
                  _buildSingleDetailsItem(
                    leading: "Created Date",
                    title: invoiceStatus?.createdDate,
                  ),
                  _buildSingleDetailsItem(
                    leading: "Expiry Date",
                    title: invoiceStatus?.expiryDate,
                  ),
                  _buildSingleDetailsItem(
                    leading: "Name",
                    title: invoiceStatus?.customerName,
                  ),
                  _buildSingleDetailsItem(
                    leading: "Mobile",
                    title: invoiceStatus?.customerMobile,
                  ),
                  _buildSingleDetailsItem(
                    leading: "Email",
                    title: invoiceStatus?.customerEmail ?? '-',
                  ),
                  _buildSingleDetailsItem(
                    leading: "Customer Reference",
                    title: invoiceStatus?.customerReference ?? '-',
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Builder(
                      builder: (context) {
                        final decoration = BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: theme.primary.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        );

                        final leadingStyle = TextStyle(
                          fontSize: 13,
                          overflow: TextOverflow.ellipsis,
                          color: theme.primary,
                          fontWeight: FontWeight.w700,
                        );
                        return Column(
                          children: [
                            _buildSingleDetailsItem(
                              leading: "Item",
                              trailing: "Price",
                              height: 50,
                              leadingStyle: leadingStyle,
                              trailingStyle: TextStyle(
                                fontSize: 13,
                                overflow: TextOverflow.ellipsis,
                                color: const Color(0xff868686),
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: decoration,
                            ),
                            ...List.generate(
                              invoiceStatus?.invoiceItems?.length ?? 0,
                              (index) {
                                return _buildSingleDetailsItem(
                                  leading: invoiceStatus
                                          ?.invoiceItems?[index].itemName ??
                                      '-',
                                  trailing: invoiceStatus
                                          ?.invoiceItems?[index].unitPrice
                                          .toString() ??
                                      '-',
                                  height: 50,
                                  leadingStyle: leadingStyle,
                                  decoration: decoration,
                                );
                              },
                            ).toList(),
                            _buildSingleDetailsItem(
                              leading: "Total",
                              trailing: invoiceStatus?.invoiceValue.toString(),
                              height: 50,
                              leadingStyle: leadingStyle,
                              decoration: decoration,
                            ),
                            _buildSingleDetailsItem(
                              leading: "Service charge",
                              trailing: "00.000",
                              height: 50,
                              leadingStyle: leadingStyle,
                              decoration: decoration,
                            ),
                            Container(
                              decoration: decoration,
                              child: Column(
                                children: [
                                  _buildSingleDetailsItem(
                                    leading: "Payment Method",
                                    trailing: "Grand Total(KD)",
                                    height: 40,
                                    trailingStyle: TextStyle(
                                      fontSize: 13,
                                      overflow: TextOverflow.ellipsis,
                                      color: const Color(0xff868686),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    leadingStyle: leadingStyle,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 15, bottom: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Transform.scale(
                                          scale: 1,
                                          child: Radio(
                                            value: true,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            groupValue: true,
                                            fillColor:
                                                MaterialStateProperty.all(
                                                    theme.primary),
                                            onChanged: null,
                                          ),
                                        ),
                                        // Image.asset(Assets.kNet),
                                        // SizedBox(width: 5.w),
                                        Text(
                                          invoiceStatus?.invoiceTransactions
                                                  ?.first.paymentGateway ??
                                              '-',
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          invoiceStatus?.invoiceDisplayValue ??
                                              '-',
                                          textAlign: TextAlign.start,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 13,
                                            overflow: TextOverflow.ellipsis,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _buildSingleDetailsItem(
                              leading: "Payment Status",
                              trailing: invoiceStatus?.invoiceStatus,
                              height: 50,
                              leadingStyle: leadingStyle,
                              decoration: decoration,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleDetailsItem({
    required String leading,
    String? title,
    TextStyle? leadingStyle,
    TextStyle? trailingStyle,
    String? trailing,
    double? height,
    BoxDecoration? decoration,
  }) {
    return Container(
      height: height ?? 30,
      decoration: decoration,
      child: ListTile(
        // minLeadingWidth: 90,

        leading: Text(
          leading,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: leadingStyle ??
              TextStyle(
                fontSize: 13,
                overflow: TextOverflow.ellipsis,
                // color: theme.primary,
                fontWeight: FontWeight.w500,
              ),
        ),
        title: title == null
            ? null
            : Text(
                title,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  color: const Color(0xff868686),
                  fontWeight: FontWeight.w400,
                ),
              ),
        trailing: trailing == null
            ? null
            : Text(
                trailing,
                textAlign: TextAlign.start,
                maxLines: 1,
                style: trailingStyle ??
                    TextStyle(
                      fontSize: 13,
                      overflow: TextOverflow.ellipsis,
                      // color:   Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
              ),
      ),
    );
  }
}
