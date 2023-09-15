import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const themeModeKey = 'themeMode';
const localeKey = 'locale';

ThemeMode themeModeFromString(String value) {
  return ThemeMode.values.firstWhere((e) => e.name == value);
}

class SettingsState extends ChangeNotifier {
  late SharedPreferences _sharedPreferences;
  ThemeMode _themeMode = ThemeMode.system;
  Locale _locale = const Locale('en');

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    if (_sharedPreferences.containsKey(themeModeKey)) {
      _themeMode =
          themeModeFromString(_sharedPreferences.getString(themeModeKey)!);
    }
    if (_sharedPreferences.containsKey(localeKey)) {
      _locale = Locale(_sharedPreferences.getString(localeKey)!);
    }
  }

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    _sharedPreferences.setString(themeModeKey, themeMode.name);
    notifyListeners();
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    _sharedPreferences.setString(localeKey, locale.languageCode);
    notifyListeners();
  }
}
