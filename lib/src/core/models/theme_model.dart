import 'package:flutter/material.dart';
import 'package:zeus_app/src/core/services/local_storage_service.dart';

class ThemeModel with ChangeNotifier {
  final LocalStorageService localStorageService;
  ThemeMode _mode;
  ThemeMode get mode => _mode;
  ThemeModel(
      {ThemeMode mode = ThemeMode.light, required this.localStorageService})
      : _mode = mode;

  void toggleMode() async {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    String storageValue = _mode == ThemeMode.dark ? "dark" : "light";
    await localStorageService.setString('themeColor', storageValue);
    notifyListeners();
  }

  Future<void> initTheme() async {
    String? themeColor = await localStorageService.getString('themeColor');
    if (themeColor != null) {
      if (themeColor == "dark") {
        _mode = ThemeMode.dark;
      } else if (themeColor == "light") {
        _mode = ThemeMode.light;
      }
    }
    notifyListeners();
  }
}
