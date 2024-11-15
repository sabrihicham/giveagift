import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/profile/login.dart';

class DialogUtils {
  static Future<bool> askForLogin(BuildContext context) async {
    if (!SharedPrefs.instance.isLogedIn.value) {
      final toLogin = await showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: Text('login_to_continue'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text('login'.tr),
            ),
          ],
        )
      );

      if (toLogin) {
        final loggedIn = await Get.to(() => const LoginPage());

        if (loggedIn != true) {
          return false;
        }
      } else {
        return false;
      }
    }

    return true;
  }

  static Future<T?> globalShowDialog<T>(
      {String? title,
      List<Widget>? content,
      String? confirmText,
      String? cancelText}) async {
    return Get.dialog<T>(AlertDialog(
      title: title != null
          ? Text(
              title,
              textAlign: TextAlign.center,
            )
          : null,
      backgroundColor: Get.isDarkMode ? null : Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actionsPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: content ?? [],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 1,
            color: Get.isDarkMode ? Colors.grey[700] : Colors.grey[300],
          )
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            backgroundColor: Get.theme.colorScheme.secondary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
          onPressed: () {
            // Get.back(result: false);
            Navigator.pop(Get.overlayContext!, false);
          },
          child: Text(
            cancelText ?? "cancel".tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            backgroundColor: Get.theme.primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
          ),
          onPressed: () {
            // Get.back(result: true);
            Navigator.pop(Get.overlayContext!, true);
          },
          child: Text(
            confirmText ?? "ok".tr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
  }
}