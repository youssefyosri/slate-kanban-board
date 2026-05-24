import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/data/auth_providers.dart';
import '../../features/auth/domain/app_user.dart';

final authStateChangesProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges();
});

final authStateProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateChangesProvider);

  return authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );
});