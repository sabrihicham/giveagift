import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:giveagift/constants/api.dart';
import 'package:giveagift/core/classes/custom_client.dart' as client;
import 'package:giveagift/core/utiles/shared_prefs.dart';
import 'package:giveagift/models/app_config.dart';

class AppConfig {
  AppConfig._();

  static Future<void> init() async {
    Stream.periodic(
      1.minutes,
      (x) => x,
    ).listen((_) async {
      await getAppConfig();
    });

    getAppConfigRefresh();
  }

  static Future<void> getAppConfigRefresh() async {
    try {
      final isDone = await getAppConfig();

      if (isDone) {
        log('App Config Refreshed');
      } else {
        Future.delayed(5.seconds, () {
          getAppConfigRefresh();
        });
      }
    } catch (e) {
      log('App Config Refresh Error: $e');
      Future.delayed(5.seconds, () {
        getAppConfigRefresh();
      });
    }
  }

  static Future<bool> getAppConfig() async {
    final response = await client.get(
      Uri.parse('${API.BASE_URL}/api/v1/configs'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final appConfig = AppConfigResponse.fromJson(jsonDecode(response.body));

      if (appConfig.status == 'success') {
          if (appConfig.data != SharedPrefs.instance.appConfig) {
            SharedPrefs.instance.setAppConfig(appConfig.data);
          }
        return true;
      }
    }

    return false;
  }
}
