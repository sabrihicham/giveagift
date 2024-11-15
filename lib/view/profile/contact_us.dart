import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/profile/join_us.dart';
import 'package:giveagift/view/profile/transfer_balance.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;

class ContactUsResponse {
  final String status;
  final String message;

  ContactUsResponse({
    required this.status,
    required this.message,
  });

  factory ContactUsResponse.fromJson(Map<String, dynamic> json) {
    return ContactUsResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _nameController = TextEditingController(),
      _phoneController = TextEditingController(),
      _emailController = TextEditingController(),
      _messageController = TextEditingController();

  CountryCode _countryCode = CountryCode.countries.first;
  bool isSuccess = false, submitting = false;
  final _formKey = GlobalKey<FormState>();

  void _onSubmit() async {
    if (isSuccess) {
      Get.back();
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (submitting) {
      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      final response = await client.post(
        Uri.parse('${API.BASE_URL}/api/v1/user/contact-us'),
        body: {
          "name": _nameController.text,
          "phone": _countryCode.code + _phoneController.text,
          "email": _emailController.text,
          "message": _messageController.text,
        },
      );

      if (response.statusCode < 500) {
        final data = jsonDecode(response.body);
        final joinUsResponse = JoinUsResponse.fromJson(data);
        if (joinUsResponse.status == 'success') {
          setState(() {
            isSuccess = true;
            submitting = false;
          });

          return;
        } else {
          Get.snackbar(
            'error'.tr,
            joinUsResponse.message,
            backgroundColor: Colors.red,
            colorText: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'error'.tr,
          'something_went_wrong'.tr,
          backgroundColor: Colors.red,
          colorText: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'something_went_wrong'.tr,
        backgroundColor: Colors.red,
        colorText: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
      );
    }

    setState(() {
      submitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: isSuccess,
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('contact_us'.tr),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: GlobalFilledButton(
                text: isSuccess ? 'home'.tr : 'send'.tr,
                onPressed: _onSubmit,
                loading: submitting,
                height: 60.h,
                width: 343.w,
              ),
            ),
          ),
          if (isSuccess)
            Center(
              child: SizedBox(
                width: 327.w,
                height: 254.h,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 150.w,
                      height: 150.w,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(),
                      child: SvgPicture.asset(
                        'assets/images/success_1.svg',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    SizedBox(
                      width: double.infinity,
                      height: 68.h,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'تم ارسال طلبكم بنجاح!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              'وسيتم مراجعة طلبك في أقرب وقت ممكن',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GlobalOutlineFormTextFeild(
                      controller: _nameController,
                      title: 'name'.tr,
                      color:
                          Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                      height: 52.h + 4,
                      textAlignVertical: TextAlignVertical.center,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please_enter_name'.tr;
                        } else if (value.length < 3) {
                          return 'name_must_be_at_least_3_characters'.tr;
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GlobalOutlineFormTextFeild(
                            controller: _phoneController,
                            title: 'phone_number'.tr,
                            color: Get.isDarkMode
                                ? Colors.grey.shade900
                                : Colors.white,
                            height: 52.h + 4,
                            expands: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please_enter_phone'.tr;
                              } else if (value.length < 9) {
                                return 'phone_must_be_at_least_9_digits'.tr;
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                          ),
                        ),
                        SizedBox(width: 4.w),
                        OutlineContainer(
                          width: 67.w,
                          height: 44,
                          radius: 11.r,
                          borderColor: Get.isDarkMode
                              ? Colors.grey[700]!
                              : const Color(0xEEEEEEEE),
                          child: CountriesButton(
                            hideFlag: true,
                            onCountryChange: (country) {
                              _countryCode = country;
                            },
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: GlobalOutlineFormTextFeild(
                        controller: _emailController,
                        title: 'email'.tr,
                        height: 52.h + 4,
                        color: Get.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.white,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_email'.tr;
                          } else if (!GetUtils.isEmail(value)) {
                            return 'please_enter_valid_email'.tr;
                          }

                          return null;
                        },
                      ),
                    ),
                    GlobalOutlineFormTextFeild(
                      controller: _messageController,
                      title: 'message'.tr,
                      color:
                          Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                      maxLines: 3,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please_enter_message'.tr;
                        } else if (value.length < 10) {
                          return 'message_must_be_at_least_10_characters'.tr;
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
