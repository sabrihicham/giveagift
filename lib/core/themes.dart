import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';

const Color defaultMainColor = Color.fromRGBO(253, 60, 132, 1);
const Color defaultSecondaryColor = Color.fromRGBO(65, 84, 123, 1);

class Themes {

  static ThemeData get theme => Get.isDarkMode ? darkTheme : lightTheme;

  static ThemeData get lightTheme => ThemeData.light().copyWith(
    // useMaterial3: false,
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.grey.shade300),
    ),
    primaryColor: SharedPrefs.instance.appConfig?.mainColor ?? defaultMainColor,
    // secondary Color
    colorScheme: ThemeData.light().colorScheme.copyWith(
      secondary: SharedPrefs.instance.appConfig?.secondaryColor
    ),
    appBarTheme: AppBarTheme(
      // backgroundColor: Color.fromRGBO(20, 21, 76, 1),
      titleTextStyle: TextStyle(
        fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
        color: const Color(0xFF222A40),
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: Color.fromRGBO(247, 247, 247, 1),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: SharedPrefs.instance.appConfig?.mainColor ?? defaultMainColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.black,
        textStyle: TextStyle(
          fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
        ),
      ),
    ),
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.grey.shade800),
    ),
    primaryColor: SharedPrefs.instance.appConfig?.mainColor ?? defaultMainColor,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      secondary: SharedPrefs.instance.appConfig?.secondaryColor
    ),
    appBarTheme: AppBarTheme(
      // backgroundColor: Color.fromRGBO(20, 21, 76, 1),
      titleTextStyle: TextStyle(
        fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
        color: Colors.white,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: Colors.black45,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    cupertinoOverrideTheme: NoDefaultCupertinoThemeData(
      brightness: Brightness.dark,
      primaryColor: SharedPrefs.instance.appConfig?.mainColor ?? defaultMainColor,
      textTheme: CupertinoTextThemeData(
        primaryColor: Colors.white,
        textStyle: TextStyle(
          fontFamily: SharedPrefs.instance.prefs.getString('lang') == 'ar' ? 'Cairo' : 'Roboto',
        ),
      ),
    ),
  );
}
