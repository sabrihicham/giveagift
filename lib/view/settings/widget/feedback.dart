import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:giveagift/constants/strings.dart';

class FeedBack extends StatelessWidget {
  const FeedBack({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return ListTile(
          title: Text('feed_back'.tr, style: const TextStyle(fontSize: 18)),
          trailing: const Icon(Icons.favorite_outline_rounded),
          onTap: () => showModalBottomSheet(
            useSafeArea: true,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))
            ),
            enableDrag: true,
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                   Text('feed_back'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                   const SizedBox(height: 20),
                   Text('feed_back_message'.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                   const SizedBox(height: 20),
                   // c
                   GestureDetector(
                      onTap: () {
                        Clipboard.setData(const ClipboardData(text: contactUsEmail));
                        // show snackbar with animation
                        Get.showSnackbar(
                          GetSnackBar(
                            message: 'email_clipbord_message'.tr,
                            duration: const Duration(seconds: 2),
                            animationDuration: const Duration(milliseconds: 500),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Get.theme.primaryColor,
                            borderRadius: 25,
                            margin: const EdgeInsets.all(20),
                            padding: const EdgeInsets.all(20),
                            icon: const Icon(Icons.check_circle_outline_rounded, color: Colors.greenAccent),
                            ),
                        );
                      },
                     child: Text(
                        contactUsEmail,
                        style: TextStyle(
                          fontSize: 18,
                          color: Get.isDarkMode ? Colors.white70: Colors.black54,
                        )
                      ),
                   )
                ]
              )
            )
          )
        );
      }
    );
  }
}
