import 'package:giveagift/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutApp extends StatelessWidget {
  final String? version;

  const AboutApp({
    super.key,
    this.version
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('about_app'.tr, style: const TextStyle(fontSize: 18)),
      trailing: const Icon(Icons.info_outline_rounded),
      onTap: () => showAboutDialog(
        context: context,
        applicationName: appName,
        applicationVersion: version ?? '',
        applicationLegalese: '©2024',
        children: [
          Text('about_app_message'.tr),
        ]
      ),
    );
  }
}
