import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/view/profile/login.dart';
import 'package:giveagift/view/settings/settings.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const Settingspage());
            },
            icon: const Icon(Icons.settings_suggest_rounded),
          ),
        ],
      ),
      body: !SharedPrefs.instance.isLogedIn
        ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'not_login_msg'.tr,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: CupertinoButton(
                  onPressed: () {
                    Get.to(
                      () => const LoginPage(),
                      transition: Transition.cupertino,
                    );
                  },
                  child: Text(
                    'login'.tr,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white
                    )
                  ),
                  color: Color.fromRGBO(253,60,132, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
          ],
        )
        :
        SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Full name
            SizedBox(
              width: double.infinity,
              child: Text(
                'Sabri Hicham'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
                maxHeight: 300
              ),
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.white.withOpacity(.1) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'balance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '1000' + ' ' + 'SAR',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 2,
                    width: 100,
                    color: Get.isDarkMode ? Colors.white.withOpacity(.1) : Colors.grey.shade200,
                  ),
                  const SizedBox(height: 10),
                  CupertinoButton(
                    onPressed: () {
                      showBottomSheet(
                        context: context, 
                        builder: (context) => Container(
                          height: 200,
                          color: Get.isDarkMode ? Colors.black : Colors.white,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                'add_balance'.tr,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              CupertinoTextField(
                                placeholder: 'amount'.tr,
                                keyboardType: TextInputType.number,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              CupertinoButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'add_balance'.tr,
                                  style: Theme.of(context).textTheme.button?.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'add_balance'.tr,
                      style: Theme.of(context).textTheme.button?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            )
          ]
        ),
      ),
    );
  }
}
