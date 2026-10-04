import 'package:flutter/material.dart';

import '../models/student.dart';
import '../theme/app_colors.dart';
import '../widgets/student_form_dialog.dart';

/// Les informations d'un étudiant, avec un bouton pour le modifier.
class StudentDetailsPage extends StatelessWidget {
  const StudentDetailsPage({super.key, required this.student});

  final Student student;

  Future<void> _edit(BuildContext context) async {
    final updated = await showDialog<Student>(
      context: context,
      builder: (_) => StudentFormDialog(student: student),
    );
    if (updated != null && context.mounted) {
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails'),
        actions: [
          IconButton(
            tooltip: 'Modifier',
            onPressed: () => _edit(context),
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.blue,
              child: Text(
                student.initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.white,
            elevation: 0,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Nom'),
                  subtitle: Text(student.name),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Filière'),
                  subtitle: Text(student.department),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
            label: const Text('Retour à la liste'),
          ),
        ],
      ),
    );
  }
}
