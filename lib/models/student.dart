/// Un étudiant : un nom et une filière.
class Student {
  const Student({required this.name, required this.department});

  final String name;
  final String department;

  /// Les initiales affichées dans l'avatar (« Paul Mbarga » → « PM »).
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.first.isEmpty) return '?';
    if (parts.length < 2) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
