import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/payment/global_payment_receipt_widget.dart';
import 'package:myfatoorah_flutter/MFModels.dart';

class PaymentStatusScreen extends StatefulWidget {
  final MFGetPaymentStatusResponse? response;
  final MFError? error;
  const PaymentStatusScreen({super.key, this.response, this.error});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen> {

  @override
  void initState() {
    if (widget.response != null) {
      print("Payment Status: ${widget.response!.invoiceStatus}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSuccess = widget.response != null && widget.response!.invoiceStatus == "Paid";
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Status"),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            Get.back();
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: SvgPicture.asset(
                  isSuccess 
                    ? 'assets/images/success.svg'
                    : 'assets/images/failed.svg',
                ),
              ),
              const SizedBox(height: 6),
              Text(
                isSuccess ? "payment_success".tr : "payment_failed".tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Visibility(
                visible: widget.response != null,
                child: GlobalPaymentReceiptWidget(
                  invoiceStatus: widget.response,
                  showMycoursesButton: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
