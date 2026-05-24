class Task {
  final String id;
  final String title;
  final String status; // 'todo', 'in_progress', 'done'

  Task({
    required this.id,
    required this.title,
    required this.status,
  });

  factory Task.fromMap(Map<String, dynamic> data, String documentId) {
    return Task(
      id: documentId,
      title: data['title'] ?? '',
      status: data['status'] ?? 'todo',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'status': status,
    };
  }
}