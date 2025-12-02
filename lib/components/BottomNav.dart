import 'package:flutter/material.dart';

enum BottomTab { home, subjects, profile }

class BottomNav extends StatelessWidget {
  final BottomTab currentTab;
  final ValueChanged<BottomTab> onTabChange;

  const BottomNav({
    Key? key,
    required this.currentTab,
    required this.onTabChange,
  }) : super(key: key);

  static const _activeColor = Color(0xFF0B1E3B);
  static const _inactiveColor = Colors.grey;

  Widget _buildItem({
    required BottomTab id,
    required IconData icon,
    required String label,
  }) {
    final isActive = id == currentTab;
    final color = isActive ? _activeColor : _inactiveColor;

    return Expanded(
      child: InkWell(
        onTap: () => onTabChange(id),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE5E7EB), width: 1), // gray-200
          ),
        ),
        padding: const EdgeInsets.only(bottom: 8, top: 6),
        child: Row(
          children: [
            _buildItem(id: BottomTab.home, icon: Icons.home_outlined, label: 'Inicio'),
            _buildItem(id: BottomTab.subjects, icon: Icons.book_outlined, label: 'Materias'),
            _buildItem(id: BottomTab.profile, icon: Icons.person_outline, label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
// ...existing code...