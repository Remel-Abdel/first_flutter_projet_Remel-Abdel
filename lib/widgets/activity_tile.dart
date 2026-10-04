import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Une ligne de l'activité récente.
class ActivityTile extends StatelessWidget {
  const ActivityTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.blue.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.blue, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12.5)),
      ),
    );
  }
}
