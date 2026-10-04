import 'package:flutter/material.dart';

import '../pages/settings_page.dart';
import '../theme/app_colors.dart';
import 'app_logo.dart';
import 'notifications_sheet.dart';

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
      title: const _HeaderTitle(),
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
        const _ProfileMenu(),
      ],
    );
  }
}

/// Logo + nom de l'application.
class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const AppLogo(size: 38),
        const SizedBox(width: 10),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Student Manager',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Gestion scolaire',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Avatar + petit menu (profil, déconnexion).
class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Profil',
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Action : $value')),
        );
      },
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: 'Mon profil',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.person_outline),
            title: Text('Mon profil'),
          ),
        ),
        PopupMenuItem(
          value: 'Déconnexion',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.logout_rounded),
            title: Text('Déconnexion'),
          ),
        ),
      ],
      child: const Padding(
        padding: EdgeInsets.only(left: 6, right: 16),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.blue,
          child: Text(
            'SM',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
