import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPrefsProvider must be overridden in main');
});

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPrefsProvider));
});

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const _themeKey = 'app_theme_mode';
  static const _rbacKey = 'user_role_cache';

  bool get isDarkMode => _prefs.getBool(_themeKey) ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_themeKey, value);

  static const _langKey = 'app_language';

  String get cachedLanguage => _prefs.getString(_langKey) ?? 'en';
  Future<void> setCachedLanguage(String code) => _prefs.setString(_langKey, code);

  String? get cachedRole => _prefs.getString(_rbacKey);
  Future<void> setCachedRole(String role) => _prefs.setString(_rbacKey, role);
}