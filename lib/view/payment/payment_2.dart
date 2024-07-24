import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/payment/payment_screen_status.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

final String mAPIKey = dotenv.get("PAYMENT_API_KEY");

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentScreen({super.key, required this.totalAmount});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String response = '';
  late final cxt = context;
  List<MFPaymentMethod> paymentMethods = [];
  List<bool> isSelected = [];
  int selectedPaymentMethodIndex = -1;

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  initiate() async {
    if (mAPIKey.isEmpty) {
      setState(() {
        response =
            "Missing API Token Key.. You can get it from here: https://myfatoorah.readme.io/docs/test-token";
      });
      return;
    }

    await MFSDK.init(mAPIKey, MFCountry.SAUDIARABIA, MFEnvironment.LIVE);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initiatePayment();
      await initiateSession();
    });
  }

  log(Object object) {
    var json = const JsonEncoder.withIndent('  ').convert(object);
    setState(() {
      if (kDebugMode) {
        print(json);
      }
      response = json;
    });
  }

  // Initiate Payment
  initiatePayment() async {
    var request = MFInitiatePaymentRequest(
        invoiceAmount: widget.totalAmount,
        currencyIso: MFCurrencyISO.SAUDIARABIA_SAR);

    try {
      final value = await MFSDK.initiatePayment(request, MFLanguage.ENGLISH);

      log(value);
      paymentMethods.addAll(value.paymentMethods!);
      selectedPaymentMethodIndex = paymentMethods.isEmpty ? -1 : 0;
      for (int i = 0; i < paymentMethods.length; i++) {
        isSelected.add(false);
      }
    } catch (error) {
      log(error);
    }
  }

  // Execute Regular Payment
  executeRegularPayment(int paymentMethodId) async {
    var request = MFExecutePaymentRequest(
      displayCurrencyIso: MFCurrencyISO.SAUDIARABIA_SAR,
      paymentMethodId: paymentMethodId,
      invoiceValue: widget.totalAmount,
      // customerName: user.firstName,
      // customerAddress: MFCustomerAddres(
      //   street: user.info.street,
      //   addressInstructions: user.info.city,
      //   block: user.info.subStreet,
      //   houseBuildingNo: user.info.home,
      // ),
      // customerMobile: user.phone,
      // customerReference: user.userId.toString(),
      // mobileCountryCode: user.countryCode.toString(),
    );
    await MFSDK.executePayment(request, MFLanguage.ENGLISH, (invoiceId) {
      log(invoiceId);
    }).then((value) {
      if (cxt.mounted) {
        Navigator.pushReplacement(
            context, 
            MaterialPageRoute(
              builder: (context) => PaymentStatusScreen(response: value)
            )
          );
      }
    }).catchError((error) {
      if (cxt.mounted) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(
            builder: (context) => PaymentStatusScreen(error: error)
          )
        );
      }
    });

    // if(result is MFGetPaymentStatusResponse ){
    //   _navigateToPaymentStatus(value);

    // }
  }

  // Cancel Recurring Payment
  cancelRecurringPayment() async {
    await MFSDK
        .cancelRecurringPayment("Put RecurringId here", MFLanguage.ENGLISH)
        .then((value) => log(value))
        .catchError((error) => {log(error.message)});
  }

  setPaymentMethodSelected(int index, bool value) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = value;
        if (value) {
          selectedPaymentMethodIndex = index;
        } else {
          selectedPaymentMethodIndex = -1;
        }
      } else {
        isSelected[i] = false;
      }
    }
  }

  executePayment() {
    if (selectedPaymentMethodIndex == -1) {
      setState(() {
        response = "Please select payment method first";
      });
    } else {
      executeRegularPayment(paymentMethods[selectedPaymentMethodIndex].paymentMethodId!);
    }
  }

  initiateSession() async {
    MFInitiateSessionRequest initiateSessionRequest = MFInitiateSessionRequest();
    await MFSDK
        .initiateSession(initiateSessionRequest, (bin) {
          log(bin);
        })
        .then((value) => {log(value)})
        .catchError((error) => {log(error.message)});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('payment'.tr),
      ),
      body: paymentMethods.isEmpty
          ? Center(
              child: Container(
                color: Colors.white.withOpacity(0.8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitFadingCircle(
                      color: theme.primary,
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    const Text("الرجاء الإنتظار"),
                  ],
                ),
              ),
            )
          : SafeArea(
              child: Flex(
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(2.5),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Directionality(
                              textDirection: TextDirection.ltr,
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  border: Border.all(
                                    width: 1,
                                    color: theme.primary.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    _buildSingleDetailsItem(
                                      leading: "Payment Method",
                                      trailing: "Grand Total(SAR)",
                                      height: 40,
                                      trailingStyle: const TextStyle(
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis,
                                        color: Color(0xff868686),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      leadingStyle: TextStyle(
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis,
                                        color: theme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    ...List.generate(
                                        paymentMethods.length,
                                        (index) => _buildPaymentMethodItem(paymentMethods[index], index))
                                  ],
                                ),
                              ),
                            ),
                            // size: Size(double.infinity.w, 50.h),
                            // margin: EdgeInsets.symmetric(vertical: 5),
                            // onTap: executePayment
                            // text: pay_now
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: ElevatedButton(
                                onPressed: executePayment,
                                child: Text('pay_now'.tr),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildPaymentMethodItem(MFPaymentMethod paymentMethod, int index) {
    if (Platform.isAndroid && paymentMethod.paymentMethodEn?.toLowerCase().contains("apple") == true) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context).colorScheme;
    
    return TextButton(
      onPressed: () {
        setState(() {
          setPaymentMethodSelected(index, true);
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Transform.scale(
              scale: 1,
              child: Radio<MFPaymentMethod>(
                value: paymentMethod,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                groupValue: selectedPaymentMethodIndex == -1
                    ? null
                    : paymentMethods[selectedPaymentMethodIndex],
                fillColor: MaterialStateProperty.all(theme.primary),
                onChanged: null,
              ),
            ),
            SizedBox(
              width: 40,
              child: Image.network(
                paymentMethod.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              paymentMethod.paymentMethodEn.toString(),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontSize: 15,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              paymentMethod.totalAmount.toString(),
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                fontSize: 13,
                color: Get.isDarkMode ? Colors.white : Colors.black,
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
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
        // minLeadingWidth: 90.w,

        leading: Text(
          leading,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: leadingStyle ??
              const TextStyle(
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
                style: const TextStyle(
                  fontSize: 13,
                  overflow: TextOverflow.ellipsis,
                  color: Color(0xff868686),
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
                    const TextStyle(
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
