import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static final SharedPrefs _instance = SharedPrefs._foo();

  SharedPrefs._foo();

  static SharedPrefs get instance => _instance;

  SharedPreferences get prefs => _prefs;

  static late SharedPreferences _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }
}
