import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:giveagift/app_navigation.dart';

void main() {
  runApp(const GiveAGift());
}

class GiveAGift extends StatelessWidget {
  const GiveAGift({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
