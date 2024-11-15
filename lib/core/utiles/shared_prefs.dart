import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:giveagift/core/classes/submission_state.dart';
import 'package:giveagift/models/app_config.dart';
import 'package:giveagift/view/cart/data/model/card.dart';
import 'package:giveagift/view/profile/controller/profile_controller.dart';
import 'package:giveagift/view/profile/model/balance.dart';
import 'package:giveagift/view/profile/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._foo();

  SharedPrefs._foo();

  static SharedPrefs get instance => _instance;

  SharedPreferences get prefs => _prefs;

  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();

    // await _prefs.remove('carts');

    // // add mock cart data
    // if (!_prefs.containsKey('carts')) {
    //   Cart cart = Cart(
    //     id: '1',
    //     items: [
    //       CartItem(
    //         id: '1',
    //         brand: '2 Gether',
    //         price: 200,
    //         cardBack: '',
    //         cardFront: '',
    //         isCustom: false,
    //         logoImage: '',
    //         codeUsed: false,
    //         isPaid: false,
    //         ready: true,
    //         status: 'active',
    //         uniqueCode: '',
    //         receiverInfo: ReceiverInfo(
    //           name: 'John Doe',
    //           phone: '1234567890',
    //         )
    //       )
    //     ],
    //   );

    //   _prefs.setStringList('carts', [jsonEncode(cart.toJson())]);
    // }
  }

  bool get firstTime => !_prefs.containsKey('firstTime');

  void setFirstTime() {
    _prefs.setBool('firstTime', false);
  }

  bool get notificationIsOn => _prefs.getBool('notificationIsOn') ?? true;

  void setNotificationIsOn(bool value) {
    _prefs.setBool('notificationIsOn', value);
  }

  AppConfigModel? get appConfig {
    final appConfigJson = _prefs.getString('appConfig');
    if (appConfigJson != null) {
      return AppConfigModel.fromJson(jsonDecode(appConfigJson));
    }
    return null;
  }

  void setAppConfig(AppConfigModel appConfig) {
    _prefs.setString('appConfig', jsonEncode(appConfig.toJson()));
  }

  List<Card>? get cards {
    final cardsJson = _prefs.getStringList('cards');
    if (cardsJson != null) {
      return cardsJson.map((e) => Card.fromJson(jsonDecode(e))).toList();
    }
    return null;
  }

  void setCards(List<Card> cards) {
    SharedPrefs.instance.prefs
        .setStringList('cards', cards.map((e) => jsonEncode(e)).toList());
  }

  Wallet? get wallet {
    final walletJson = _prefs.getString('wallet');
    if (walletJson != null) {
      return Wallet.fromJson(jsonDecode(walletJson));
    }
    return null;
  }

  void setWallet(Wallet wallet) {
    _prefs.setString('wallet', jsonEncode(wallet.toJson()));
  }

  User? get user {
    final userJson = _prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  void setUser(User user) {
    _prefs.setString('user', jsonEncode(user.toJson()));
  }

  String? get token => _prefs.getString('token');

  String? get refreshToken => _prefs.getString('refreshToken');

  void setToken(String token) {
    isLogedIn.value = true;
    _prefs.setString('token', token);
  }

  void setRefreshToken(String token) {
    _prefs.setString('refreshToken', token);
  }

  void clearToken() {
    _prefs.remove('token');
    _prefs.remove('refreshToken');
    _prefs.remove('user');
    _prefs.remove('cards');
    isLogedIn.value = false;
    Get.find<ProfileController>().setState(const InitialState());
  }

  final isLogedIn = ValueNotifier(_prefs.containsKey('token'));
}
