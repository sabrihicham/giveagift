import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cart/controller/cart_controller.dart';
import 'package:giveagift/view/profile/forgot_password.dart';
import 'package:giveagift/view/profile/model/auth.dart';
import 'package:giveagift/view/profile/signup.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final message = ValueNotifier<String>('');

  final submitting = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
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
            // back Button
            Align(
              alignment: Get.locale?.languageCode == 'ar'
                  ? Alignment.topRight
                  : Alignment.topLeft,
              child: SafeArea(
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    CupertinoIcons.back,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'don\'t_have_account'.tr,
            //         style: const TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       const SizedBox(width: 10),
            //       GestureDetector(
            //         onTap: () {
            //
            //         },
            //         child: Text('create_account'.tr),
            //       ),
            //     ],
            //   ),
            // ),
            SafeArea(
              child: AutofillGroup(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: 149.7.w,
                      height: 38.h,
                    ),
                    SizedBox(height: 69.h),
                    // OutlineContainer(
                    //   // controller: emailController,
                    //   title: 'email'.tr,
                    //   // placeholder: 'example@gmail.com',
                    //   child: TextField(),
                    // ),
                    // GlobalTextField(
                    //   controller: passwordController,
                    //   title: 'password'.tr,
                    //   obscureText: true,
                    // ),
                    // // forget password
                    // Container(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15),
                    //   width: double.infinity,
                    //   constraints: BoxConstraints(maxWidth: 500),
                    //   child: GestureDetector(
                    //     onTap: () async {
                    //       final result = await Get.to(() => const ForgotPassword());
                
                    //       if (result == true) {
                    //         Get.snackbar(
                    //           'success'.tr,
                    //           'password_reset_success'.tr,
                    //           backgroundColor: Colors.green,
                    //         );
                    //       }
                    //     },
                    //     child: Text(
                    //       'forget_password'.tr,
                    //       textAlign: TextAlign.start,
                    //       style: const TextStyle(
                    //         // color: Get.isDarkMode
                    //         //     ? Colors.white
                    //         //     : Colors.black,
                    //         fontSize: 14,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      width: 343.w,
                      height: 216.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'login'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Get.isDarkMode
                                ? const Color(0xFF838383)
                                : const Color(0xFF222A40),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: 343.w,
                            height: 56.h,
                            child: GlobalTextField2(
                              controller: emailController,
                              placeHolder: 'email'.tr,
                              autofillHints: const [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              prefix: SvgPicture.asset(
                                'assets/icons/mail-outline.svg',
                                width: 22.53.w,
                                height: 22.h,
                                // fit: BoxFit.fill,
                              ),
                            )
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: 343.w,
                            height: 56.h,
                            child: GlobalTextField2(
                              controller: passwordController,
                              placeHolder: 'password'.tr,
                              autofillHints: const [AutofillHints.password],
                              keyboardType: TextInputType.visiblePassword,
                              obsecure: true,
                              prefix: SvgPicture.asset(
                                'assets/icons/lock.svg',
                                width: 22.53.w,
                                height: 22.h,
                                // fit: BoxFit.fill,
                              ),
                            )
                          ),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CupertinoButton(
                                  onPressed: () async {
                                    final result = await Get.to(
                                        () => const ForgotPassword());
                
                                    if (result == true) {
                                      Get.snackbar(
                                        'success'.tr,
                                        'password_reset_success'.tr,
                                        backgroundColor: Colors.green,
                                      );
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  child: Text(
                                    'forget_password'.tr,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: const Color(0xFF838383),
                                      fontSize: 12.sp,
                                      fontFamily: 'Almarai',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                      },
                    ),
                    SizedBox(height: 31.h),
                    // is Schadualed check box with date picker
                    ValueListenableBuilder(
                        valueListenable: submitting,
                        builder: (context, value, _) {
                          return GlobalFilledButton(
                            // padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            width: 346.w,
                            height: 60.h,
                            borderColor: Get.isDarkMode
                                ? Colors.grey[200]!
                                : Colors.grey[800]!,
                            text: 'login'.tr,
                            loading: value,
                            onPressed: () async {
                              if (value) {
                                return;
                              }
                
                              if (emailController.text.isEmpty ||passwordController.text.isEmpty) {
                                message.value = 'الرجاء إدخال البيانات';
                                return;
                              } else if (!GetUtils.isEmail(emailController.text)) {
                                message.value = 'البريد الإلكتروني غير صحيح';
                                return;
                              } else if (passwordController.text.length < 6) {
                                message.value =
                                    'كلمة المرور يجب أن تكون أكثر من 6 أحرف';
                                return;
                              } else {
                                message.value = '';
                              }
                        
                              // login
                              // {{URL}}/api/v1/auth/login
                              submitting.value = true;
                
                              // set Connection Time Out
                
                              try {
                                final response = await client.post(
                                  Uri.parse(
                                    '${API.BASE_URL}/api/v1/auth/login',
                                  ),
                                  body: {
                                    'email': emailController.text,
                                    'password': passwordController.text,
                                  },
                                );
                
                                if (response.statusCode == 200) {
                                  // Autofill
                                  TextInput.finishAutofillContext();
                                  // decode response
                                  final auth = AuthResponse.fromJson(json.decode(response.body));
                                  // save token
                                  SharedPrefs.instance.setToken(auth.token);
                                  // save user
                                  SharedPrefs.instance.setUser(auth.data.user);
                                  // Get cart
                                  Get.find<CartController>().getCards();
                                  // back to previous screen
                                  Navigator.of(context).pop(true);
                                } else if (response.statusCode == 429) {
                                  message.value = response.body;
                                } else {
                                  message.value = json.decode(response.body)['message'] ?? 'error'.tr;
                                }
                              } catch (e) {
                                log(
                                  e.toString(),
                                  error: e,
                                );
                
                                if (e is http.ClientException) {
                                  Get.showSnackbar(GetSnackBar(
                                    title: e.message,
                                    snackPosition: SnackPosition.BOTTOM,
                                    snackStyle: SnackStyle.FLOATING,
                                  ));
                                }
                              } finally {
                                submitting.value = false;
                              }
                            },
                          );
                        }),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: 343.w,
                      height: 23.h,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 146.w,
                            height: 1,
                            color: Get.isDarkMode ? Colors.black : const Color(0xFFF9F9FB),
                          ),
                          SizedBox(width: 13.w),
                          Text(
                            'or'.tr,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Get.isDarkMode ? Colors.white : Color(0xFF222A40),
                              fontSize: 12.sp,
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 13.w),
                          Container(
                            width: 146.w,
                            height: 1,
                            color: Get.isDarkMode ? Colors.black : const Color(0xFFF9F9FB),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    CupertinoButton(
                      onPressed: () => Get.to(() => const SignupPage()),
                      padding: EdgeInsets.zero,
                      child: Text(
                        'create_account'.tr,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFB62026),
                          fontSize: 12.sp,
                          fontFamily: 'Almarai',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GlobalTextField2 extends StatefulWidget {
  const GlobalTextField2({
    super.key,
    required this.controller,
    this.placeHolder,
    this.prefix,
    this.suffix,
    this.inputFormatters,
    this.keyboardType,
    this.obsecure = false,
    this.autofillHints
  });

  final TextEditingController controller;
  final String? placeHolder;
  final Widget? prefix, suffix;
  final TextInputType? keyboardType;
  final bool obsecure;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;

  @override
  State<GlobalTextField2> createState() => _GlobalTextField2State();
}

class _GlobalTextField2State extends State<GlobalTextField2> {
  bool isSecure = false;

  @override
  void initState() {
    isSecure = widget.obsecure;
    super.initState();
  }

  TextStyle get textStyle => TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Almarai',
    color: Get.isDarkMode ? Colors.white : Colors.black
  );

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: widget.controller,
      autofillHints: widget.autofillHints,
      textAlignVertical: TextAlignVertical.center,
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      placeholder: widget.placeHolder,
      style: textStyle,
      placeholderStyle: textStyle,
      obscureText: isSecure,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      prefix: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: widget.prefix,
      ),
      suffix: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: widget.obsecure 
          ? IconButton(
              onPressed: () {
                setState(() {
                  isSecure = !isSecure;
                });
              },
              color: const Color(0xFF979797),
              icon: Icon(
                !isSecure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              ),
            )
          : widget.suffix,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? null : const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          width: 1.w,
          color: const Color(0xFFE4DFDF),
        )
      ),
    );
  }
}
