import 'package:flutter/material.dart';

import '../data/sample_students.dart';
import '../models/student.dart';
import '../widgets/student_card.dart';
import '../widgets/student_form_dialog.dart';
import 'student_details_page.dart';

/// La liste des étudiants, avec un bouton pour en ajouter.
class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final List<Student> _students = List.of(sampleStudents);

  Future<void> _addStudent() async {
    final student = await showDialog<Student>(
      context: context,
      builder: (_) => const StudentFormDialog(),
    );
    if (student != null) {
      setState(() => _students.add(student));
    }
  }

  Future<void> _openDetails(int index) async {
    final updated = await Navigator.push<Student>(
      context,
      MaterialPageRoute(
        builder: (_) => StudentDetailsPage(student: _students[index]),
      ),
    );
    if (updated != null) {
      setState(() => _students[index] = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        itemCount: _students.length,
        itemBuilder: (context, index) {
          return StudentCard(
            student: _students[index],
            onTap: () => _openDetails(index),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStudent,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Ajouter'),
      ),
    );
  }
}
