import 'package:envied/envied.dart';
part 'env_prod.g.dart';

@Envied(path: '.env.prod')
abstract class EnvProd {
  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _EnvProd.apiUrl;

  @EnviedField(varName: 'STRIPE_PUBLISHABLE_KEY', obfuscate: true)
  static final String stripePublishableKey = _EnvProd.stripePublishableKey;
}