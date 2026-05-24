import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Environment { dev, prod }

class AppConfig {
  final Environment environment;
  final String apiUrl;
  final String stripePublishableKey;

  AppConfig({
    required this.environment,
    required this.apiUrl,
    required this.stripePublishableKey,
  });
}

final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden in main.dart');
});