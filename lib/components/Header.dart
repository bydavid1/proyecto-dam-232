import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? rightAction;

  const Header({
    Key? key,
    required this.title,
    this.showBack = false,
    this.onBack,
    this.rightAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (showBack)
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: IconButton(
                        icon: const Icon(Icons.chevron_left, size: 24, color: Colors.grey),
                        onPressed: onBack ?? () => Navigator.maybePop(context),
                        splashRadius: 20,
                        tooltip: 'Back',
                      ),
                    ),
                  Text(
                    title.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B1E3B),
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
              rightAction ?? const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}