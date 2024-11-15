import 'package:giveagift/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widget/settings_widgets.dart';

class Settingspage extends StatefulWidget {
  const Settingspage({super.key});

  @override
  State<Settingspage> createState() => _SettingspageState();
}

class _SettingspageState extends State<Settingspage> with WidgetsBindingObserver {
  Locale? initialLocale;

  @override
  void initState() {
    initialLocale = Get.locale;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return ListView(
                    children: [
                      const DarkModeSwitch(),
                      const LanguageSelector(),
                      const Divider(),
                      AboutApp(
                        version: snapshot.data?.version
                      ),
                      const Privacy(),
                      const FeedBack(),
                      const Divider(),
                      // App version
                      ListTile(
                        title: Text('version'.tr, style: const TextStyle(fontSize: 18)),
                        trailing: Text(
                          snapshot.data?.version ?? '',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).primaryColor),
                        )
                      )
                    ],
                  );
                }
              ),
            ),
            
          ],
        ),
      );
  }
}
