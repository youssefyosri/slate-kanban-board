import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_provider.dart';
import '../storage/shared_prefs_provider.dart';
import 'user_role.dart';

final rbacProvider = FutureProvider<UserRole>((ref) async {
  final user = await ref.watch(authStateChangesProvider.future);
  final localStorage = ref.watch(localStorageProvider);

  if (user == null) {
    await localStorage.setCachedRole(UserRole.guest.name);
    return UserRole.guest;
  }

  // Fetch the role from the Database
  // TODO: Replace with your actual Firestore call later
  // Example: final doc = await FirebaseFirestore.instance.collection('users').doc(user.id).get();
  // final fetchedRole = UserRoleX.fromString(doc.data()?['role']);

  // Mock fetch for now:
  await Future.delayed(const Duration(milliseconds: 500));
  final fetchedRole = UserRole.admin;

  await localStorage.setCachedRole(fetchedRole.name);

  return fetchedRole;
});

final cachedRoleProvider = Provider<UserRole>((ref) {
  ref.watch(rbacProvider);

  final localStorage = ref.watch(localStorageProvider);
  return UserRoleX.fromString(localStorage.cachedRole);
});