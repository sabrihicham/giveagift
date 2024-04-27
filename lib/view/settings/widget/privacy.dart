import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/webview.dart';

class Privacy extends StatelessWidget {
  const Privacy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('privacy'.tr, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.privacy_tip_outlined),
      onTap: () => Get.to(InAppWebViewPage(arguments: WebViewArguments(url: 'https://giveagift.app/privacy', title: 'Privacy Policy'))),
    );
  }
}
