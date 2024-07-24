import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/profile/forgot_password.dart';
import 'package:giveagift/view/profile/signup.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'don\'t_have_account'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const SignupPage());
                    },
                    child: Text('create_account'.tr),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'login'.tr,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/images/logo.webp',
                  width: 200,
                  height: 100,
                ),
                GlobalTextField(
                  controller: emailController,
                  placeholder: 'email'.tr,
                ),
                GlobalTextField(
                  controller: passwordController,
                  placeholder: 'password'.tr,
                  obscureText: true,
                ),
                // forget password
                GestureDetector(
                  onTap: () {
                    Get.to(() => const ForgotPassword());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Text(
                      'forget_password'.tr,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
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
                    onTap: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          message.value = 'الرجاء إدخال البيانات';
                        return;
                        
                      } else if (!GetUtils.isEmail(emailController.text)) {
                        message.value = 'البريد الإلكتروني غير صحيح';
                        return;
                      } else if (passwordController.text.length < 6) {
                        message.value = 'كلمة المرور يجب أن تكون أكثر من 6 أحرف';
                        return;
                      } else {
                        message.value = '';
                      }
                  
                    },
                    child: Text('login'.tr),
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