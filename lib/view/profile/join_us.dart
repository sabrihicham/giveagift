import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart';
import 'package:giveagift/view/profile/transfer_balance.dart';
import 'package:giveagift/view/widgets/global_filled_button.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;

class JoinUsResponse {
  final String status;
  final String message;

  JoinUsResponse({
    required this.status,
    required this.message,
  });

  factory JoinUsResponse.fromJson(Map<String, dynamic> json) {
    return JoinUsResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}

class JoinUsPage extends StatefulWidget {
  const JoinUsPage({super.key});

  @override
  State<JoinUsPage> createState() => _JoinUsPageState();
}

class _JoinUsPageState extends State<JoinUsPage> {
  final TextEditingController _nameController = TextEditingController(),
      _descriptionController = TextEditingController(),
      _linkController = TextEditingController(),
      _phoneController = TextEditingController(),
      _emailController = TextEditingController();
  CountryCode _countryCode = CountryCode.countries.first;
  bool isSuccess = false, submitting = false;
  final _formKey = GlobalKey<FormState>();

  bool get isKeyboardAppear => MediaQuery.of(context).viewInsets.bottom == 0;

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
        Uri.parse('${API.BASE_URL}/api/v1/shops/join-us'),
        body: {
          "name": _nameController.text,
          "description": _descriptionController.text,
          "link": _linkController.text,
          "phone": _countryCode.code + _phoneController.text,
          "email": _emailController.text,
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(joinUsResponse.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,

            ),
          );
          // Get.snackbar(
          //   'error'.tr,
          //   joinUsResponse.message,
          //   backgroundColor: Colors.red,
          //   colorText: Colors.white,
          // );
        }
      } else {
        // Get.snackbar(
        //   'error'.tr,
        //   'something_went_wrong'.tr,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('something_went_wrong'.tr),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              
            ),
          );
      }
    } catch (e) {
      // Get.snackbar(
      //   'error'.tr,
      //   'something_went_wrong'.tr,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('something_went_wrong'.tr),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          
        ),
      );
    }

    setState(() {
      submitting = false;
    });
  }

  Widget _buildSubmissionButton() => Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: GlobalFilledButton(
          text: isSuccess ? 'home'.tr : 'send'.tr,
          onPressed: _onSubmit,
          height: 60.h,
          width: 343.w,
        ),
      ),
    );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: isSuccess,
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('join_us_msg'.tr),
      ),
      body: Stack(
        children: [
          // if keyboard appear make it false
          if (isKeyboardAppear)
            _buildSubmissionButton(),
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
                    Container(
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
                              'تم استلام طلب الانضمام بنجاح!',
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
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GlobalOutlineFormTextFeild(
                        controller: _nameController,
                        title: 'store_name'.tr,
                        color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                        height: 52.h + 4,
                        textAlignVertical: TextAlignVertical.center,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_store_name'.tr;
                          } else if (value.length < 3) {
                            return 'store_name_must_be_at_least_3_characters'.tr;
                          }
              
                          return null;
                        },
                      ),
                      GlobalOutlineFormTextFeild(
                        controller: _descriptionController,
                        title: 'message'.tr,
                        color:
                            Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                        maxLines: 3,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_store_description'.tr;
                          } else if (value.length < 10) {
                            return 'store_description_must_be_at_least_10_characters'.tr;
                          }
              
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: GlobalOutlineFormTextFeild(
                          controller: _linkController,
                          title: 'store_link'.tr,
                          color: Get.isDarkMode
                            ? Colors.grey.shade900
                            : Colors.white,
                          height: 52.h + 4,
                          expands: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please_enter_store_link'.tr;
                            } else if (!GetUtils.isURL(value)) {
                              return 'please_enter_valid_link'.tr;
                            }
              
                            return null;
                          },
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: GlobalOutlineTextFeild(
                              controller: _phoneController,
                              title: 'phone_number'.tr,
                              // color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                              height: 52.h,
                              expands: true,
                              // validator: (value) {
                              //   if (value!.isEmpty) {
                              //     return 'please_enter_phone'.tr;
                              //   } else if (value.length < 9) {
                              //     return 'phone_must_be_at_least_9_digits'.tr;
                              //   }
                              //   return null;
                              // },
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          OutlineContainer(
                            width: 67.w,
                            height: 52.h,
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
                      SizedBox(height: 10.h),
                      if (!isKeyboardAppear)
                        _buildSubmissionButton()
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
