import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OverlayUtils {
  static Future showLoadingOverlay(
      {String? text, required Future Function() asyncFunction}) async {
    return await Get.showOverlay(
      asyncFunction: () async {
        try {
          return await asyncFunction();
        } catch (e) {
          log(e.toString(), error: e);
        }

        return null;
      },
      loadingWidget: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Get.isDarkMode ? Colors.grey[900]! : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Get.isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  blurRadius: 4.0,
                  spreadRadius: 1.0,
                  offset: const Offset(0.0, 0.0),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image.asset(
                //   'assets/images/logo.webp',
                //   width: 50,
                // ),
                const CircularProgressIndicator.adaptive(),
                if (text != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(text),
                  ),
              ],
            ),
          ),
        ),
      ),
      opacity: 0,
    );
  }

  static void hideLoadingOverlay(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget? child;
  final String? text;

  const LoadingOverlay(
      {super.key, required this.isLoading, this.child, this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          if (child != null) child!,
          isLoading
              ? Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const CircularProgressIndicator.adaptive(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          text ?? '${'loading'.tr}...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
