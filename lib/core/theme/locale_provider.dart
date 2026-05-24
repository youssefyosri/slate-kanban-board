import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/shared_prefs_provider.dart';

const supportedLanguages = [
  {'code': 'en', 'name': 'English'},
  {'code': 'ar', 'name': 'العربية'},
];

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final langCode = ref.watch(localStorageProvider).cachedLanguage;
    return Locale(langCode);
  }

  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    await ref.read(localStorageProvider).setCachedLanguage(languageCode);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);