import 'package:acservermanager/models/enums/shared_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedManager {
  final SharedPreferences _prefs;

  const SharedManager(this._prefs);

  Future<bool> setString(SharedKey key, String value) async {
    return _prefs.setString(key.name, value);
  }

  Future<String?> getString(SharedKey key) async {
    return _prefs.getString(key.name);
  }

  Future<bool> setBool(SharedKey key, bool value) async {
    return await _prefs.setBool(key.name, value);
  }

  bool? getBool(SharedKey key) {
    return _prefs.getBool(key.name);
  }
}
