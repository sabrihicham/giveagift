import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final message = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Back Button
            Align(
              alignment: Get.locale?.languageCode == 'ar'
                ? Alignment.topRight
                : Alignment.topLeft,
              child: CupertinoButton(
                onPressed: () {
                  Get.back();
                },
                child: const Icon(
                  CupertinoIcons.back,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'signup'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GlobalTextField(
                  controller: firstNameController,
                  placeholder: 'first_name'.tr,
                ),
                GlobalTextField(
                  controller: lastNameController,
                  placeholder: 'last_name'.tr,
                ),
                GlobalTextField(
                  controller: emailController,
                  placeholder: 'email'.tr,
                ),
                GlobalTextField(
                  controller: phoneController,
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
                GlobalTextField(
                  controller: passwordController,
                  placeholder: 'password'.tr,
                  obscureText: true,
                  // obscureText: true,
                ),
                ValueListenableBuilder<String>(
                  valueListenable: message,
                  builder: (context, value, child) {
                    return Text(
                      value,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                      ? Colors.grey[800]
                      : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Get.isDarkMode
                        ? Colors.grey[200]!
                        : Colors.grey[800]!,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      // login
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        message.value = 'fill_all_fields'.tr;
                      } else {
                        // login
                      }
                    },
                    child: Text('signup'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}