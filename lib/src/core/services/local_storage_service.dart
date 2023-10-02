import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<String?> getString(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> setString(String key, String input) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, input);
  }

  Future<void> remove(String key) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
