import 'package:flutter/widgets.dart';
import 'package:giveagift/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/view/settings/widget/dark_mode_switch.dart';
import 'package:number_paginator/number_paginator.dart';

import '../settings/widget/settings_widgets.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> with WidgetsBindingObserver {
  Locale? initialLocale;

  @override
  void initState() {
    initialLocale = Get.locale;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Container(
                
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    Image.network("https://i.imgur.com/22VKXCu.png"),
                    const Text("Nova",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text("NOVA STORE")
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: NumberPaginator(
            numberPages: 10,
            onPageChange: (int index) {
              // handle page change...
            },
          ),
        )
      ],
    );
  }
}
