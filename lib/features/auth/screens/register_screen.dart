import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/utils/app_ui_utils.dart';
import '../data/auth_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      AppUIUtils.showError(context, 'Passwords do not match');
      return;
    }

    AppUIUtils.showLoadingOverlay(context);

    try {
      await ref.read(authRepositoryProvider).registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        AppUIUtils.hideLoadingOverlay(context);
        AppUIUtils.showSuccess(context, 'Account created successfully!');
      }
    } catch (e) {
      if (mounted) {
        AppUIUtils.hideLoadingOverlay(context);
        AppUIUtils.showError(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Create Account',
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
                  value != null && value.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                const Gap(16),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: true,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please confirm your password' : null,
                ),
                const Gap(32),
                AppButton.primary(
                  text: 'Sign Up',
                  onPressed: _handleRegistration,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}