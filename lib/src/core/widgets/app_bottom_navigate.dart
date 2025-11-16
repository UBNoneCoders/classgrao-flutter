import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index != currentIndex) {
            if (onTap != null) {
              onTap!(index);
            } else {
              _handleNavigation(context, index);
            }
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF00695C),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Nova Classificação',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Conta',
          ),
        ],
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    // Remove todas as rotas anteriores e navega para a nova
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (route) => route.settings.name == '/auth' || route.isFirst,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/classification-form',
          (route) => route.settings.name == '/auth' || route.isFirst,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/account',
          (route) => route.settings.name == '/auth' || route.isFirst,
        );
        break;
    }
  }
}
