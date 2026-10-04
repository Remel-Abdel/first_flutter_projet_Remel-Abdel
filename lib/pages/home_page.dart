import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/activity_tile.dart';
import '../widgets/quick_action.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';
import '../widgets/welcome_banner.dart';

/// L'écran d'accueil : on assemble des petits widgets les uns sous les autres.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const WelcomeBanner(),
        const SizedBox(height: 20),

        const SectionTitle('Statistiques'),
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 132,
          ),
          children: const [
            StatCard(
              icon: Icons.people_alt_rounded,
              value: '248',
              label: 'Étudiants',
              color: AppColors.blue,
            ),
            StatCard(
              icon: Icons.menu_book_rounded,
              value: '12',
              label: 'Cours',
              color: AppColors.green,
            ),
            StatCard(
              icon: Icons.fact_check_rounded,
              value: '94%',
              label: 'Présence',
              color: AppColors.amber,
            ),
            StatCard(
              icon: Icons.emoji_events_rounded,
              value: '14,2',
              label: 'Moyenne générale',
              color: AppColors.pink,
            ),
          ],
        ),
        const SizedBox(height: 20),

        const SectionTitle('Actions rapides'),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            QuickAction(
              icon: Icons.person_add_alt_1_rounded,
              label: 'Ajouter un étudiant',
              onTap: () {},
            ),
            QuickAction(
              icon: Icons.add_box_rounded,
              label: 'Nouveau cours',
              onTap: () {},
            ),
            QuickAction(
              icon: Icons.checklist_rounded,
              label: 'Faire l\'appel',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 20),

        const SectionTitle('Activité récente'),
        const ActivityTile(
          icon: Icons.person_add_alt_1_rounded,
          title: 'Nouvel étudiant inscrit',
          subtitle: 'Aminata Diallo • il y a 10 min',
        ),
        const ActivityTile(
          icon: Icons.edit_note_rounded,
          title: 'Notes mises à jour',
          subtitle: 'Développement mobile • il y a 1 h',
        ),
        const ActivityTile(
          icon: Icons.event_available_rounded,
          title: 'Appel effectué',
          subtitle: 'Base de données • il y a 3 h',
        ),
      ],
    );
  }
}
