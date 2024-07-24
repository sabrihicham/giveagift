import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/payment/controller/payment_controller.dart';
import 'package:giveagift/view/payment/payment_2.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key, 
    required this.cartId,
    required this.amount,
  });

  final String cartId;
  final int amount;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final PaymentController controller;
  final message = ValueNotifier<String>('');

  @override
  void initState() {
    controller = Get.put(PaymentController(widget.cartId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ask for name, email, phone number
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlobalTextField(
              controller: controller.nameController,
              placeholder: 'name'.tr,
            ),
            GlobalTextField(
              controller: controller.emailController,
              placeholder: 'email'.tr,
            ),
            GlobalTextField(
              controller: controller.phoneController,
              placeholder: 'phone_number'.tr,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              prefix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '+966',
                  style: TextStyle(
                    color: Get.isDarkMode
                      ? Colors.grey[400]
                      : Colors.grey[600],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ),
            // error message
            ValueListenableBuilder<String>(
              valueListenable: message,
              builder: (context, value, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                );
              }
            ),
            // is Schadualed check box with date picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children:[
                    Checkbox(
                      value: controller.scheduleDate != null,
                      onChanged: (value) {
                        controller.scheduleDate = value! ? DateTime.now() : null;
                        setState(() {
                          
                        });
                        controller.update();
                      },
                    ),
                    const Text('Schedule')
                  ]
                ),
                const SizedBox(height: 20),
                if(controller.scheduleDate != null)
                  ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), 
                        firstDate: DateTime.now(), 
                        lastDate: DateTime.now().add(const Duration(days: 30))
                      ).then((value) {
                        controller.scheduleDate = value;
                        controller.update();
                      });
                    },
                    child: const Text('Select Date'),
                  ),
                if(controller.scheduleDate != null)
                  Text(controller.scheduleDate!.toIso8601String()),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                if (controller.nameController.text.isEmpty || controller.phoneController.text.isEmpty || controller.emailController.text.isEmpty) {
                    message.value = 'الرجاء إدخال البيانات';
                  return;
                  
                } else if (!controller.phoneController.text.startsWith('6') && !controller.phoneController.text.startsWith('5')) {
                  message.value = 'رقم الجوال يجب أن يبدأ بـ 5 أو 6';
                  return;
                } else if (controller.phoneController.text.length < 9) {
                  message.value = 'رقم الجوال يجب أن يكون 9 أرقام';
                  return;
                } else {
                  message.value = '';
                }

                Get.to(() => PaymentScreen(totalAmount: widget.amount.toDouble()));
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }
}