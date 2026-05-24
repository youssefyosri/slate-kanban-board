import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/env/app_config.dart';
import 'core/env/env_dev.dart';
import 'core/router/app_router.dart';
import 'core/storage/shared_prefs_provider.dart';
import 'core/firebase/firebase_options_dev.dart' as dev_options;
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/locale_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'core/notifications/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: dev_options.DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    if (!e.toString().contains('duplicate-app')) {
      rethrow;
    }
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  }

  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  final prefs = await SharedPreferences.getInstance();

  final devConfig = AppConfig(
    environment: Environment.dev,
    apiUrl: EnvDev.apiUrl,
    stripePublishableKey: EnvDev.stripePublishableKey,
  );

  final notificationService = PushNotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(devConfig),
        sharedPrefsProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final isDev = ref.watch(appConfigProvider).environment == Environment.dev;
    final currentThemeMode = ref.watch(themeModeProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Slate',
      debugShowCheckedModeBanner: isDev,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: currentThemeMode,
      locale: currentLocale,
      routerConfig: router,
    );
  }
}