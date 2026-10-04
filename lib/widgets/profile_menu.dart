import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Avatar + petit menu (profil, déconnexion).
class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

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
