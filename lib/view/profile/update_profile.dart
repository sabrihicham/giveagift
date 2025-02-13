import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/core/utiles/image_utils.dart';
import 'package:giveagift/core/utiles/loading_overlay.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/cards/pages/custom_card_page.dart' hide OutlineContainer;
import 'package:giveagift/view/cards/pages/ready_card_page.dart';
import 'package:giveagift/view/payment/payment.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/model/user.dart';
import 'package:giveagift/view/profile/profile.dart';
import 'package:giveagift/view/widgets/global_text_field.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  late ProfileController profileController;

  User? get user => profileController.user;

  String? imagePath;

  final nameController = TextEditingController(),
      emailController = TextEditingController(),
      phoneController = TextEditingController();

  final newPasswordController = TextEditingController(),
      confirmPasswordController = TextEditingController(),
      oldPasswordController = TextEditingController();

  final updatePasswordformKey = GlobalKey<FormState>(),
      updateProfileformKey = GlobalKey<FormState>();

  @override
  void initState() {
    profileController = Get.find<ProfileController>();
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneController.text = user?.phone ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.white.withOpacity(0.1) : null,
      appBar: AppBar(
        title: Text('update_profile'.tr),
        surfaceTintColor: Colors.transparent,
      ),
      body: GetBuilder<ProfileController>(
        init: profileController,
        builder: (controller) {
          return !controller.isLoggedIn.value
            ? NotLogedIn(
                onLogIn: (value) {
                  if (value) {
                    setState(() {});
                    controller.onInit();
                  }
                },
              )
            : GetBuilder<ProfileController>(
              id: 'updateProfile',
              builder: (controller) {
                return Center(
                  child: SingleChildScrollView(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Column(
                          children: [
                            if (controller.user?.phoneVerified == false)
                              Container(
                                width: double.infinity,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      "verify_phone_msg".tr,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: Colors.white
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        // buttton color 255, 193, 7
                                        GlobalButton(
                                          lable: 'send_code'.tr,
                                          color: Theme.of(context).primaryColor,
                                          onTap: () async {
                                            await OverlayUtils.showLoadingOverlay(
                                              text: 'sending_code'.tr,
                                              asyncFunction: () async {
                                                await profileController.getVerificationCode();
                                              }
                                            );

                                            if (profileController.getVerificationCodeState is SubmissionSuccess) {
                                              TextEditingController pinController = TextEditingController();
                                              ValueNotifier<String> _message = ValueNotifier("");

                                              SnackBarHelper.showSnackBar(
                                                title: "success".tr,
                                                message: (profileController.getVerificationCodeState as SubmissionSuccess).message ?? 'verification_sent'.tr,
                                                color: Colors.green
                                              );

                                              final result = await Get.dialog(
                                                barrierDismissible: false,
                                                Dialog(
                                                  backgroundColor: Get.isDarkMode
                                                    ? null
                                                    : Colors.white,
                                                  child: ConstrainedBox(
                                                    constraints: const BoxConstraints(
                                                      maxWidth: 500,
                                                      maxHeight: 400,
                                                    ),
                                                    child: Container(
                                                      margin: const EdgeInsets.all(20),
                                                      padding: const EdgeInsets.all(8),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(8)
                                                      ),
                                                      child: ValueListenableBuilder(
                                                        valueListenable: _message,
                                                        builder: (context, value, _) => Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              "verify_phone_description".tr,
                                                              textAlign: TextAlign.center,
                                                              style: Theme.of(context).textTheme.titleLarge
                                                            ),
                                                            const SizedBox(height: 20),
                                                            ConstrainedBox(
                                                              constraints: BoxConstraints(maxWidth: 150),
                                                              child: GlobalTextField(
                                                                controller: pinController,
                                                                textSize: 35,
                                                                textAlign: TextAlign.center,
                                                                backgroundColor: Colors.transparent,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter.digitsOnly
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
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                GetBuilder(
                                                                  init: profileController,
                                                                  id: 'verifyPhone',
                                                                  builder: (controller) => GlobalButton(
                                                                    lable: "vreify".tr,
                                                                    showLoading: controller.verifyPhoneState is Submitting,
                                                                    borderRadius: 100,
                                                                    onTap: () async {
                                                                      if (controller.verifyPhoneState is Submitting) {
                                                                        return;
                                                                      }

                                                                      if (pinController.value.text.isEmpty) {
                                                                        _message.value = "empty_feild".tr;
                                                                        return;
                                                                      } else if (pinController.value.text.length < 6) {
                                                                        _message.value = '${"pin_minimim".tr} 6.';
                                                                        return;
                                                                      } else {
                                                                        _message.value = "";
                                                                      }

                                                                      await profileController.verifyPhone(pinController.text);

                                                                      bool isSuccess = false;
                                                                      String? message;

                                                                      if (profileController.verifyPhoneState is SubmissionSuccess) {
                                                                        Get.back(result: true);
                                                                        isSuccess = true;
                                                                        message = (profileController.verifyPhoneState as SubmissionSuccess).message ?? 'phone_verify_success'.tr;
                                                                      } else {
                                                                        message = (profileController.verifyPhoneState as SubmissionError).exception.message;
                                                                      }

                                                                      SnackBarHelper.showSnackBar(title: isSuccess ? "success".tr : "error".tr, message: message, color: isSuccess ? Colors.green : Colors.red);
                                                                    },
                                                                  ),
                                                                ),
                                                                GlobalButton(
                                                                  lable: "cancel".tr,
                                                                  color: Theme.of(context).colorScheme.secondary,
                                                                  borderRadius: 100,
                                                                  onTap: () => Get.back(result: false),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ),
                                                  ),
                                                ),
                                              );
                                            } else if (profileController.getVerificationCodeState is SubmissionError) {
                                              return SnackBarHelper.showSnackBar(
                                                title: 'error'.tr,
                                                message: (profileController.getVerificationCodeState as SubmissionError).exception.message,
                                                color: Colors.red,
                                              );
                                            }
                                          },
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            OutlineContainer(
                              title: 'update_profile'.tr,
                              borderRadius: BorderRadius.circular(10),
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: updateProfileformKey,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                ? Colors.white.withOpacity(.1)
                                                : Colors.grey.shade200,
                                              shape: BoxShape.circle
                                            ),
                                            clipBehavior: Clip.antiAlias,
                                            child: imagePath != null
                                                ? Image.file(
                                                    File(imagePath!),
                                                    height: 100,
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: "${API.BASE_URL}/users/${SharedPrefs.instance.user!.photo}",
                                                  ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Theme.of(context).scaffoldBackgroundColor,
                                                borderRadius: BorderRadius.circular(50),
                                              ),
                                              child: InkWell(
                                                child: const Icon(
                                                  Icons.camera_alt,
                                                  size: 24,
                                                ),
                                                onTap: () async {
                                                  final ImagePicker picker = ImagePicker();
                                                  final XFile? image = await picker.pickImage(
                                                    source: ImageSource.gallery
                                                  );

                                                  if (image != null) {
                                                    setState(() {
                                                      imagePath = image.path;
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    GlobalOutlineFormTextFeild(
                                      controller: nameController,
                                      title: 'name'.tr,
                                      color: Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                      height: 50.h,
                                      textAlignVertical: TextAlignVertical.center,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    GlobalOutlineFormTextFeild(
                                      controller: emailController,
                                      title: 'email'.tr,
                                      color: Get.isDarkMode ? Colors.grey.shade900 :   Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                      placeholder: 'example@gmail.com',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    GlobalOutlineFormTextFeild(
                                      controller: phoneController,
                                      title: 'phone_number'.tr,
                                      color: Get.isDarkMode ? Colors.grey.shade900 :  Colors.white,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10
                                      ),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: GlobalButton(
                                          lable: 'update'.tr,
                                          onTap: () async {
                                            if (updateProfileformKey.currentState!.validate()) {
                                              await OverlayUtils.showLoadingOverlay(
                                                text: 'update'.tr,
                                                asyncFunction: () async {
                                                  XFile? image;

                                                  if (imagePath != null) {
                                                    try {
                                                      image = await ImageUtils.testCompressAndGetFile(File(imagePath!));
                                                    } catch (e) {
                                                      log(
                                                        e.toString(),
                                                        error: e,
                                                      );
                                                    }
                                                  }

                                                  await controller.updateProfile(
                                                    name: nameController.text.isNotEmpty && nameController.text != user?.name
                                                      ? nameController.text
                                                      : null,
                                                    email: emailController.text.isNotEmpty && emailController.text != user ?.email
                                                      ? emailController.text
                                                      : null,
                                                    phone: phoneController.text.isNotEmpty && phoneController.text != user?.phone
                                                      ? phoneController.text
                                                      : null,
                                                    imagePath: image?.path
                                                  );
                                                },
                                              );

                                              if (controller.updateProfileState is SubmissionSuccess) {
                                                Get.snackbar(
                                                  'success'.tr,
                                                  'profile_updated'.tr,
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                              } else if (controller.updateProfileState is SubmissionError) {
                                                Get.snackbar(
                                                  'error'.tr,
                                                  (controller.updateProfileState as SubmissionError).exception.message,
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            OutlineContainer(
                              title: 'change_password'.tr,
                              borderRadius: BorderRadius.circular(10),
                              padding: const EdgeInsets.all(20),
                              child: Form(
                                key: updatePasswordformKey,
                                child: Column(
                                  children: [
                                    GlobalOutlineFormTextFeild(
                                      controller: oldPasswordController,
                                      title: 'old_password'.tr,
                                      color:  Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'empty_old_pass'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    GlobalOutlineFormTextFeild(
                                      controller: newPasswordController,
                                      title: 'new_password'.tr,
                                      color:  Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'empty_new_pass'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    GlobalOutlineFormTextFeild(
                                      controller: confirmPasswordController,
                                      title: 'confirm_password'.tr,
                                      color:  Get.isDarkMode ? Colors.grey.shade900 : Colors.white,
                                      validator: (value) {
                                        if (value == null ||
                                            value.isEmpty) {
                                          return 'empty_confirm_pass'.tr;
                                        }
                                        if (value !=
                                            newPasswordController.text) {
                                          return 'password_not_match'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: GlobalButton(
                                          lable: 'update'.tr,
                                          onTap: () async {
                                            if (updatePasswordformKey.currentState!.validate()) {
                                              await OverlayUtils.showLoadingOverlay(
                                                text: 'update'.tr,
                                                asyncFunction: () async {
                                                  await controller.updatePassword(oldPasswordController.text, newPasswordController.text);
                                                },
                                              );

                                              if (controller.updatePasswordState is SubmissionSuccess) {
                                                Get.snackbar(
                                                  'success'.tr,
                                                  'password_updated'.tr,
                                                  snackPosition: SnackPosition.TOP,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                );
                                              } else if (controller.updatePasswordState is SubmissionError) {
                                                Get.snackbar(
                                                  'error'.tr,
                                                  (controller.updatePasswordState as SubmissionError).exception.message,
                                                  snackPosition: SnackPosition.TOP,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
        },
      ),
    );
  }
}

class GlobalButton extends StatelessWidget {
  final String lable;
  final Function()? onTap;
  final Color? color;
  final double? borderRadius;
  final bool showLoading;
  const GlobalButton(
      {super.key,
      required this.lable,
      this.onTap,
      this.color,
      this.borderRadius,
      this.showLoading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(borderRadius ?? 10),
      ),
      child: CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        child: LayoutBuilder(builder: (context, constrained) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Text(
                lable,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          );
        }),
      ),
    );
  }
}
