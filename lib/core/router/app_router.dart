import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../../features/tasks/screens/task_board_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(authStateProvider);
  final analytics = FirebaseAnalytics.instance;

  return GoRouter(
    initialLocation: '/',
    observers: [
      FirebaseAnalyticsObserver(analytics: analytics),
    ],
    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      final isAuthScreen = isLoggingIn || isRegistering;

      if (!isAuthenticated && !isAuthScreen) {
        return '/login';
      }

      if (isAuthenticated && isAuthScreen) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'tasks',
        builder: (context, state) => const TaskBoardScreen(),
      ),
    ],
  );
});