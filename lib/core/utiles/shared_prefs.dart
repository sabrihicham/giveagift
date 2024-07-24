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

  String? get token => _prefs.getString('token');

  void setToken(String token) {
    _prefs.setString('token', token);
  }

  void clearToken() {
    _prefs.remove('token');
  }

  bool get isLogedIn {
    return true;
  }
}
