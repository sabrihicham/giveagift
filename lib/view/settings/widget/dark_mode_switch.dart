import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkModeSwitch extends StatefulWidget {
  const DarkModeSwitch({super.key});

  @override
  State<DarkModeSwitch> createState() => _DarkModeSwitchState();
}

class _DarkModeSwitchState extends State<DarkModeSwitch> {

   // change theme to dark
  void onChanged(bool isDark) {
    setState(() {
      // change theme
      Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
      // save in shared preferences
      SharedPrefs.instance.prefs.setBool('isDark', isDark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      thumbIcon: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.nightlight_round, color: Colors.black);
        }
        return const Icon(Icons.wb_sunny, color: Colors.amber);
      }),
      title: Text('dark_mode'.tr, style: const TextStyle(fontSize: 18)),
      value: SharedPrefs.instance.prefs.getBool('isDark') ?? false,
      onChanged: onChanged
    );
  }
}
