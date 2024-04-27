import 'package:flutter/material.dart';

class Themes {
  static final lightTheme = ThemeData.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
      fontFamily: 'Ara Hamah 1982',
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.grey.shade300),
    ),
    primaryColor: Colors.brown,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(20, 21, 76, 1),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.white,
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    textTheme: ThemeData.dark().textTheme.apply(
      fontFamily: 'Ara Hamah 1982',
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(Colors.white),
      trackColor: MaterialStateProperty.all(Colors.black87),
    ),
    primaryColor: Colors.brown,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(20, 21, 76, 1),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    scaffoldBackgroundColor: Colors.black45,
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
  );
}
