import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/app_header.dart';
import 'home_page.dart';
import 'placeholder_page.dart';

/// Le cadre de l'application : header en haut, page au milieu,
/// barre de navigation en bas.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    HomePage(),
    PlaceholderPage(
      icon: Icons.people_alt_rounded,
      title: 'Étudiants',
      message: 'La liste des étudiants apparaîtra ici.',
    ),
    PlaceholderPage(
      icon: Icons.menu_book_rounded,
      title: 'Cours',
      message: 'Les cours et les emplois du temps apparaîtront ici.',
    ),
    PlaceholderPage(
      icon: Icons.bar_chart_rounded,
      title: 'Notes',
      message: 'Les notes et les résultats apparaîtront ici.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppHeader(notificationCount: 3),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded, color: AppColors.blue),
            label: 'Accueil',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_alt_rounded, color: AppColors.blue),
            label: 'Étudiants',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded, color: AppColors.blue),
            label: 'Cours',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: AppColors.blue),
            label: 'Notes',
          ),
        ],
      ),
    );
  }
}
