import 'dart:convert';

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

  List<String> get favorites => _prefs.getStringList('favorites') ?? <String>[];

  List<String> get favoritesLeague => _prefs.getStringList('favorites_league') ?? <String>[];


  Future<void> addTrLeague(String key, String value) async {
    if (_prefs.containsKey("tr_league")) {
      final trLeague = _prefs.getString("tr_league");

      final trLeague0 = json.decode(trLeague!) as Map<String, dynamic>;

      trLeague0[key] = value;

      await _prefs.setString("tr_league", json.encode(trLeague0));
    } else {
      await _prefs.setString("tr_league", json.encode({key: value}));
    }
  }

  Map<String, dynamic>? get trLeague {
    final trLeague = _prefs.getString("tr_league");

    if (trLeague == null) {
      return null;
    }

    return json.decode(trLeague) as Map<String, dynamic>;
  }

  String? getTrLeauge(String key) {
    return trLeague?[key];
  }

  Future<void> clearTrLeague() async {
    await _prefs.remove("tr_league");
  }

  String getTranslatedLeague(String key) {
    return _prefs.getString(key) ?? "";
  }

  String? getTranslatedTeams(String key) {
    return _prefs.getString(key);
  }

  List<String> getTeam(String id) {
    return _prefs.getString("team_$id")?.split(",") ?? <String>[];
  }

  Future<void> addFavorite(String id, String teamName, String teamLogo) async {
    await _prefs.setStringList('favorites', [...favorites, id]);
    await _prefs.setString("team_$id", "$teamName,$teamLogo");
  }

  Future<void> removeFavorite(String id) async {
    await _prefs.setStringList('favorites', favorites.where((element) => element != id).toList());
    await _prefs.remove("team_$id");
  }

  List<String> getLeague(String id) {
    return _prefs.getString("league_$id")?.split(",") ?? <String>[];
  }

  Future<void> addFavoriteLeague(String id, String leagueName, String leagueLogo) async {
    await _prefs.setStringList('favorites_league', [...favoritesLeague, id]);
    await _prefs.setString("league_$id", "$leagueName,$leagueLogo");
  }

  Future<void> removeFavoriteLeague(String id) async {
    await _prefs.setStringList('favorites_league', favoritesLeague.where((element) => element != id).toList());
    await _prefs.remove("league_$id");
  }
}
