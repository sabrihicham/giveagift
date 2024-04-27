import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';

class LanguageSelector extends StatefulWidget {
  const LanguageSelector({super.key});

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final languageCode = <String>['ar', 'en'];
  final languageCodeMap = {'ar': 'العربية', 'en': 'English'};

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('language'.tr, style: const TextStyle(fontSize: 18)),
      trailing: DropdownButton<String>(
        value: SharedPrefs.instance.prefs.containsKey('lang') 
          ? SharedPrefs.instance.prefs.getString('lang')
          : 'ar',
        onChanged: (String? newValue) {
          setState(() {
            // save in shared preferences
            SharedPrefs.instance.prefs.setString('lang', newValue!);
            // change language
            Get.updateLocale(Locale(newValue));
          });
        },
        items: languageCode.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem<String>(
            value: value,
            child: Text(
              languageCodeMap[value] ?? 'null',
              style: const TextStyle(fontSize: 18),
            ),
          )).toList(),
      ),
    );
  }
}
