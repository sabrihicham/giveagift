import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/view/profile/login.dart';
import 'package:giveagift/view/profile/model/signup.dart';
import 'package:giveagift/view/profile/transfer_balance.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String phoneBegining = '966';

  final message = ValueNotifier<String>('');
  final submitting = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : null,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -148,
            left: 197,
            child: Container(
              width: 388.w,
              height: 387.h,
              decoration: ShapeDecoration(
                color: const Color(0x028D181C),
                shape: OvalBorder(
                  side:
                      BorderSide(width: 3.w, color: const Color(0x0C8D181C)),
                ),
              ),
            ),
          ),
          Positioned(
            top: -329.h,
            left: 269.w,
            child: Container(
              width: 496.w,
              height: 496.h,
              decoration: ShapeDecoration(
                color: const Color(0x028D181C),
                shape: OvalBorder(
                  side:
                      BorderSide(width: 1.w, color: const Color(0x0C8D181C)),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  width: double.infinity,
                  child: Text(
                    'signup'.tr,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 343.w,
                  height: 56.h,
                  child: GlobalTextField2(
                    controller: nameController,
                    placeHolder: 'name'.tr,
                    prefix: SvgPicture.asset(
                      'assets/icons/mail-outline.svg',
                      width: 22.53.w,
                      height: 22.h,
                      // fit: BoxFit.fill,
                    ),
                  )
                ),
                SizedBox(height: 19.h),
                SizedBox(
                  width: 343.w,
                  height: 56.h,
                  child: GlobalTextField2(
                    controller: emailController,
                    placeHolder: 'email'.tr,
                    prefix: SvgPicture.asset(
                      'assets/icons/mail-outline.svg',
                      width: 22.53.w,
                      height: 22.h,
                      // fit: BoxFit.fill,
                    ),
                  )
                ),
                SizedBox(height: 19.h),
                SizedBox(
                  width: 343.w,
                  height: 56.h,
                  child: GlobalTextField2(
                    controller: phoneController,
                    placeHolder: 'phone_number'.tr,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefix: CountriesButton(
                      hideFlag: true,
                      onCountryChange: (country) {
                        phoneBegining = country.code;
                      },
                    ),
                  )
                ),
                SizedBox(height: 19.h),
                SizedBox(
                  width: 343.w,
                  height: 56.h,
                  child: GlobalTextField2(
                    controller: passwordController,
                    placeHolder: 'password'.tr,
                    prefix: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      width: 22.53.w,
                      height: 22.h,
                      // fit: BoxFit.fill,
                    ),
                  )
                ),
                SizedBox(height: 19.h),
                SizedBox(
                  width: 343.w,
                  height: 56.h,
                  child: GlobalTextField2(
                    controller: confirmPasswordController,
                    placeHolder: 'confirm_password'.tr,
                    prefix: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      width: 22.53.w,
                      height: 22.h,
                      // fit: BoxFit.fill,
                    ),
                  )
                ),
                SizedBox(height: 19.h),
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
                SizedBox(height: 10.h),
                ValueListenableBuilder(
                  valueListenable: submitting,
                  builder: (context, value, _) {
                    return GlobalFilledButton(
                      // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      // decoration: BoxDecoration(
                      //   color:
                      //       Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      //   borderRadius: BorderRadius.circular(10),
                      //   border: Border.all(
                      //     color: Get.isDarkMode
                      //         ? Colors.grey[200]!
                      //         : Colors.grey[800]!,
                      //   ),
                      // ),
                      width: 346.w,
                      height: 60.h,
                      borderColor: Get.isDarkMode
                          ? Colors.grey[200]!
                          : Colors.grey[800]!,
                      text: 'signup'.tr,
                      loading: value,
                      onPressed: () async {
                        if (value) {
                          return;
                        }
                          
                        submitting.value = true;
                          
                        try {
                          // login
                          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                            message.value = 'fill_all_fields'.tr;
                          } else if (passwordController.text != confirmPasswordController.text) {
                            message.value = 'unmatch_password'.tr;
                          } else {
                            message.value = '';
                            
                            final response = await client.post(
                              Uri.parse('${API.BASE_URL}/api/v1/auth/signup'),
                              body: {
                                'name': nameController.text,
                                'email': emailController.text,
                                'phone': '$phoneBegining${phoneController.text}',
                                'password': passwordController.text,
                                'passwordConfirm': confirmPasswordController.text,
                              },
                            );
                          
                            final responseJson = SignUpResponse.fromJson(json.decode(response.body));
                          
                            if (response.statusCode == 201) {
                              Get.back();
                            } else {
                              message.value = responseJson.message ?? 'error'.tr;
                            }
                          }
                        } catch (e) {
                          message.value = 'error'.tr;
                        }
                          
                        submitting.value = false;
                      }
                      // child: ValueListenableBuilder(
                      //     valueListenable: submitting,
                      //     builder: (context, value, child) {
                      //       return !value
                      //           ? Text('signup'.tr)
                      //           : const CircularProgressIndicator.adaptive(
                      //               valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      //               backgroundColor: Colors.white,
                      //             );
                      //     }),
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
