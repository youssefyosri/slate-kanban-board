import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/utils/app_ui_utils.dart';
import '../data/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    // 1. Trigger your global loading overlay
    AppUIUtils.showLoadingOverlay(context);

    try {
      // 2. Execute the auth repository method
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        // 3. Hide overlay on success.
        // Note: No context.go('/home') needed here! Your router guard
        // will automatically detect the state change and redirect.
        AppUIUtils.hideLoadingOverlay(context);
      }
    } catch (e) {
      if (mounted) {
        // 4. Hide overlay and show standard error toast on failure
        AppUIUtils.hideLoadingOverlay(context);
        AppUIUtils.showError(context, 'Failed to sign in. Please check your credentials.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Gap(32),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(32),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email Address',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Email is required' : null,
                ),
                const Gap(16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Password is required' : null,
                ),
                const Gap(24),
                AppButton.primary(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                ),
                const Gap(16),
                AppButton.outline(
                  text: 'Create an Account',
                  onPressed: () => context.push('/register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}