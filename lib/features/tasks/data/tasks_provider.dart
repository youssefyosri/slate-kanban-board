import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'task_model.dart';

final tasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('tasks')
      .where('userId', isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => Task.fromMap(doc.data(), doc.id))
      .toList());
});

final todoTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  return tasks.where((task) => task.status == 'todo').toList();
});

final inProgressTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  return tasks.where((task) => task.status == 'in_progress').toList();
});

final doneTasksProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  return tasks.where((task) => task.status == 'done').toList();
});

Future<void> updateTaskStatus(String taskId, String newStatus) async {
  await FirebaseFirestore.instance
      .collection('tasks')
      .doc(taskId)
      .update({'status': newStatus});
}

Future<void> createNewTask(String title) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null || title.trim().isEmpty) return;

  await FirebaseFirestore.instance.collection('tasks').add({
    'title': title.trim(),
    'status': 'todo',
    'userId': user.uid,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

Future<void> deleteTask(String taskId) async {
  await FirebaseFirestore.instance.collection('tasks').doc(taskId).delete();
}