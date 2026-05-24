import 'package:flutter/material.dart';

enum _ButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final _ButtonType _type;

  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _type = _ButtonType.primary;

  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _type = _ButtonType.secondary;

  const AppButton.outline({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : _type = _ButtonType.outline;

  @override
  Widget build(BuildContext context) {
    final action = isLoading ? null : onPressed;
    final theme = Theme.of(context);

    // Dynamically adjust spinner color: White for solid buttons, Primary for outline buttons
    final spinnerColor = _type == _ButtonType.outline
        ? theme.colorScheme.primary
        : theme.colorScheme.onPrimary;

    final loadingWidget = SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(strokeWidth: 2, color: spinnerColor),
    );

    // Helper to dynamically build the inside of the button
    Widget buildContent() {
      if (isLoading) return loadingWidget;
      if (icon != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 8),
            Text(text),
          ],
        );
      }
      return Text(text);
    }

    switch (_type) {
      case _ButtonType.primary:
        return ElevatedButton(
          onPressed: action,
          child: buildContent(),
        );
      case _ButtonType.secondary:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
          ),
          onPressed: action,
          child: buildContent(),
        );
      case _ButtonType.outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: action,
          child: buildContent(),
        );
    }
  }
}