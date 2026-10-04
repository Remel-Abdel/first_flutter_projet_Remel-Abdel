import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import '../theme/app_colors.dart';
import 'header_title.dart';
import 'notifications_sheet.dart';
import 'profile_menu.dart';

/// La barre du haut : logo, titre, cloche, paramètres et profil.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppHeader({super.key, required this.notificationCount});

  final int notificationCount;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  void _openNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => const NotificationsSheet(),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      titleSpacing: 16,
      title: const HeaderTitle(),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => _openNotifications(context),
          icon: Badge(
            isLabelVisible: notificationCount > 0,
            label: Text('$notificationCount'),
            backgroundColor: AppColors.amber,
            textColor: AppColors.ink,
            child: const Icon(Icons.notifications_none_rounded, size: 26),
          ),
        ),
        IconButton(
          tooltip: 'Paramètres',
          onPressed: () => _openSettings(context),
          icon: const Icon(Icons.settings_outlined, size: 25),
        ),
        const ProfileMenu(),
      ],
    );
  }
}
