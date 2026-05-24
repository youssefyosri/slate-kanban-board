import 'package:envied/envied.dart';
part 'env_dev.g.dart';

@Envied(path: '.env.dev')
abstract class EnvDev {
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _EnvDev.apiUrl;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY', obfuscate: true)
  static final String stripePublishableKey = _EnvDev.stripePublishableKey;
}