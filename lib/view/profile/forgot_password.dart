import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/profile/login.dart';
import 'package:giveagift/view/profile/update_profile.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  final message = ValueNotifier<String>('');
  final submitting = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Theme.of(context).cardColor : null,
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
                child: Icon(
                  CupertinoIcons.back,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                  size: 30,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'restore_password'.tr,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
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
                    )),
                SizedBox(height: 5.h),
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
                SizedBox(height: 5.h),
                GlobalFilledButton(
                  width: 346.w,
                  height: 60.h,
                  borderColor:
                      Get.isDarkMode ? Colors.grey[200]! : Colors.grey[800]!,
                  text: 'send'.tr,
                  onPressed: () async {
                    if (submitting.value) {
                      return;
                    }

                    if (emailController.text.isEmpty) {
                      message.value = 'please_enter_email'.tr;
                      return;
                    } else {
                      message.value = '';
                    }

                    submitting.value = true;

                    try {
                      // Call API to send email
                      final response = await client.post(
                        Uri.parse('${API.BASE_URL}/api/v1/auth/forgotPassword'),
                        body: {
                          'email': emailController.text,
                        },
                      );

                      final body = json.decode(response.body);

                      if (response.statusCode == 200) {
                        Get.snackbar(
                          'success'.tr,
                          body['message'] ?? 'email_sent'.tr,
                          backgroundColor: Colors.green,
                        );

                        TextEditingController pinController =
                            TextEditingController();
                        ValueNotifier<String> _message = ValueNotifier("");
                        ValueNotifier<bool> _verifing = ValueNotifier(false);

                        final result = await Get.dialog(
                            Dialog(
                              backgroundColor:
                                  Get.isDarkMode ? null : Colors.white,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                  maxHeight: 400,
                                ),
                                child: Container(
                                    margin: const EdgeInsets.all(20),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: ValueListenableBuilder(
                                      valueListenable: _message,
                                      builder: (context, value, _) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text("verify_email_description".tr,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge),
                                          const SizedBox(height: 20),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(maxWidth: 180),
                                            child: GlobalTextField(
                                              controller: pinController,
                                              textSize: 35,
                                              textAlign: TextAlign.center,
                                              backgroundColor:
                                                  Colors.transparent,
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            _message.value,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              ValueListenableBuilder(
                                                valueListenable: _verifing,
                                                builder: (context, value, _) =>
                                                    GlobalButton(
                                                  lable: "vreify".tr,
                                                  borderRadius: 100,
                                                  onTap: () async {
                                                    if (_verifing.value) {
                                                      return;
                                                    }

                                                    if (pinController
                                                        .value.text.isEmpty) {
                                                      _message.value =
                                                          "empty_feild".tr;
                                                      return;
                                                    } else if (pinController
                                                            .value.text.length <
                                                        6) {
                                                      _message.value =
                                                          '${"pin_minimim".tr} 6.';
                                                      return;
                                                    } else {
                                                      _message.value = "";
                                                    }

                                                    final result = await client
                                                        .post(
                                                            Uri.parse(
                                                                '${API.BASE_URL}/api/v1/auth/verifyResetCode'),
                                                            body: {
                                                          'resetCode':
                                                              pinController.text
                                                        });

                                                    final body = json
                                                        .decode(response.body);

                                                    if (response.statusCode ==
                                                        200) {
                                                      bool isSuccess = false;
                                                      String? message;

                                                      if (body['status']
                                                              .toString()
                                                              .toLowerCase() ==
                                                          'success') {
                                                        Get.back(result: true);
                                                        isSuccess = true;
                                                        message = body[
                                                                'message'] ??
                                                            'phone_verify_success'
                                                                .tr;
                                                      } else {
                                                        message =
                                                            body['message'] ??
                                                                '-'.tr;
                                                      }

                                                      SnackBarHelper
                                                          .showSnackBar(
                                                              title: isSuccess
                                                                  ? "success".tr
                                                                  : "error".tr,
                                                              message: message!,
                                                              color: isSuccess
                                                                  ? Colors.green
                                                                  : Colors.red);
                                                    } else {
                                                      Get.snackbar(
                                                        'error'.tr,
                                                        body['message'] ?? "-",
                                                        backgroundColor:
                                                            Colors.red,
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              GlobalButton(
                                                lable: "cancel".tr,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                borderRadius: 100,
                                                onTap: () =>
                                                    Get.back(result: false),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                            barrierDismissible: false);

                        ValueNotifier<bool> _changing = ValueNotifier(false);

                        if (result == true) {
                          final _result = await Get.dialog(
                            Dialog(
                              backgroundColor:
                                  Get.isDarkMode ? null : Colors.white,
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxWidth: 500,
                                  maxHeight: 400,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text("reset_password".tr,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      const SizedBox(height: 20),
                                      GlobalTextField(
                                        controller: emailController,
                                        title: 'email'.tr,
                                        placeholder: 'example@email.com',
                                      ),
                                      const SizedBox(height: 5),
                                      GlobalTextField(
                                        controller: newPasswordController,
                                        title: 'password'.tr,
                                        obscureText: true,
                                      ),
                                      const SizedBox(height: 5),
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
                                      const SizedBox(height: 5),
                                      GlobalButton(
                                        lable: "ok".tr,
                                        borderRadius: 100,
                                        onTap: () async {
                                          if (_changing.value) {
                                            return;
                                          }

                                          if (emailController.text.isEmpty) {
                                            message.value = 'email_required'.tr;
                                            return;
                                          } else {
                                            message.value = '';
                                          }

                                          if (newPasswordController
                                              .text.isEmpty) {
                                            message.value =
                                                'password_required'.tr;
                                            return;
                                          } else {
                                            message.value = '';
                                          }

                                          _changing.value = true;

                                          try {
                                            // Call API to send email
                                            final response = await client.put(
                                              Uri.parse(
                                                  '${API.BASE_URL}/api/v1/auth/resetPassword'),
                                              body: {
                                                'email': emailController.text,
                                                'newPassword':
                                                    newPasswordController.text,
                                              },
                                            );

                                            final body =
                                                json.decode(response.body);

                                            if (response.statusCode == 200) {
                                              Get.back(result: true);
                                              Get.back(result: true);
                                            } else {
                                              Get.snackbar(
                                                'error'.tr,
                                                body['message'] ?? '-'.tr,
                                                backgroundColor: Colors.red,
                                              );
                                            }
                                          } catch (e) {
                                            Get.snackbar(
                                              'error'.tr,
                                              'server_error_message'.tr,
                                              backgroundColor: Colors.red,
                                            );
                                          }

                                          _changing.value = false;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                          if (_result == true) {
                            Get.back(result: true);
                          }
                        }
                      } else {
                        Get.snackbar(
                          'error'.tr,
                          body['message'] ?? 'email_not_sent'.tr,
                          backgroundColor: Colors.red,
                        );
                      }
                    } catch (e) {
                      Get.snackbar(
                        'error'.tr,
                        'server_error_message'.tr,
                        backgroundColor: Colors.red,
                      );
                    }

                    submitting.value = false;
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
