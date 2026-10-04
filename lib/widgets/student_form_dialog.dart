import 'package:flutter/material.dart';

import '../models/student.dart';

/// Formulaire pour ajouter (ou modifier) un étudiant.
class StudentFormDialog extends StatefulWidget {
  const StudentFormDialog({super.key, this.student});

  /// Si on donne un étudiant, le formulaire sert à le modifier.
  final Student? student;

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: widget.student?.name);
  late final _departmentController =
      TextEditingController(text: widget.student?.department);

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        name: _nameController.text.trim(),
        department: _departmentController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        widget.student == null ? 'Ajouter un étudiant' : 'Modifier l\'étudiant',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nom complet',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le nom est obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _departmentController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Filière',
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _save, child: const Text('Enregistrer')),
      ],
    );
  }
}
