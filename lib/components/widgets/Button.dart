import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, danger }

class Button extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final EdgeInsetsGeometry padding;

  const Button({
    Key? key,
    required this.child,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
  }) : super(key: key);

  Color _background(BuildContext context) {
    switch (variant) {
      case ButtonVariant.secondary:
        return const Color(0xFFF3F4F6); // gray-100
      case ButtonVariant.outline:
        return Colors.transparent;
      case ButtonVariant.danger:
        return const Color(0xFFEF4444); // red-500
      case ButtonVariant.primary:
      default:
        return const Color(0xFF0B1E3B);
    }
  }

  Color _foreground(BuildContext context) {
    switch (variant) {
      case ButtonVariant.secondary:
      case ButtonVariant.outline:
        return const Color(0xFF374151); // gray-700
      case ButtonVariant.danger:
      case ButtonVariant.primary:
      default:
        return Colors.white;
    }
  }

  BorderSide? _border() {
    if (variant == ButtonVariant.outline) {
      return const BorderSide(color: Color(0xFFD1D5DB)); // gray-300
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _background(context);
    final fg = _foreground(context);
    final side = _border();

    final ButtonStyle style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size.fromHeight(48)),
      padding: WidgetStateProperty.all(padding),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled)) return bg.withOpacity(0.5);
          return bg;
        },
      ),
      foregroundColor: WidgetStateProperty.all(fg),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      )),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: side ?? BorderSide.none,
      )),
      overlayColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.pressed)) {
            return fg.withOpacity(0.08);
          }
          return null;
        },
      ),
      elevation: WidgetStateProperty.all(0),
    );

    final Widget button = ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: child,
    );

    return SizedBox(width: double.infinity, child: button);
  }
}
