import 'app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();

  Future<AppUser?> signInWithEmailAndPassword(String email, String password);

  Future<AppUser?> registerWithEmailAndPassword(String email, String password);

  Future<void> signOut();

  Future<void> deleteAccount();
}