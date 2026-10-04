import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Le panneau qui monte du bas quand on touche la cloche.
class NotificationsSheet extends StatelessWidget {
  const NotificationsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1_rounded, color: AppColors.blue),
            title: Text('Nouvelle inscription'),
            subtitle: Text('Aminata Diallo a rejoint la classe L2 Info'),
          ),
          ListTile(
            leading: Icon(Icons.event_rounded, color: AppColors.amber),
            title: Text('Examen demain'),
            subtitle: Text('Développement mobile • 08h00'),
          ),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            title: Text('Absences répétées'),
            subtitle: Text('3 étudiants dépassent le seuil autorisé'),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
