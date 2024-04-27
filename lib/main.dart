import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:giveagift/app_navigation.dart';
import 'package:giveagift/core/localization/local.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  runApp(const GiveAGift());
}

class GiveAGift extends StatelessWidget {
  const GiveAGift({super.key});
  final locales = const {'en': Locale('en'), 'ar': Locale('ar')};

  Locale get locale => SharedPrefs.instance.prefs.containsKey('lang')
      ? locales[SharedPrefs.instance.prefs.getString('lang')]!
      : locales['ar']!;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MyLocal(),
      locale: locale,
      title: 'Give A Gift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey[200]!),
        fontFamily: 'Ara Hamah 1982',
        useMaterial3: true,
      ),
      home: const AppNavigation(),
    );
  }
}
