import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/shared_prefs_provider.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final isDark = ref.watch(localStorageProvider).isDarkMode;
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = state == ThemeMode.dark;

    state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;

    await ref.read(localStorageProvider).setDarkMode(!isCurrentlyDark);
  }
}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);