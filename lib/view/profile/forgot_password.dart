import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();

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
                  'restore_password'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GlobalTextField(
                  controller: emailController,
                  placeholder: 'email'.tr,
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
                      Get.back();
                    },
                    child: Text(
                      'send'.tr,
                      style: TextStyle(
                        color: Get.isDarkMode
                          ? Colors.grey[200]
                          : Colors.grey[800],
                      ),
                    ),
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