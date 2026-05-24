import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/features/tasks/data/tasks_provider.dart';
import '/features/tasks/data/task_model.dart';
import '../../../shared/widgets/theme_toggle_button.dart';

class TaskBoardScreen extends ConsumerWidget {
  const TaskBoardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'SLATE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
          const ThemeToggleButton(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    left: 24,
                    right: 24,
                    top: 24,
                  ),
                  child: const _AddTaskForm(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColumn(context, 'TO-DO', 'todo', todoTasksProvider),
            const SizedBox(width: 16),
            _buildColumn(context, 'IN PROGRESS', 'in_progress', inProgressTasksProvider),
            const SizedBox(width: 16),
            _buildColumn(context, 'DONE', 'done', doneTasksProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(BuildContext context, String title, String statusId, Provider<List<Task>> provider) {
    final columnWidth = MediaQuery.of(context).size.width * 0.85;

    return DragTarget<Task>(
      onAcceptWithDetails: (details) {
        final task = details.data;
        if (task.status != statusId) {
          updateTaskStatus(task.id, statusId);
        }
      },
      builder: (context, candidateItems, rejectedItems) {
        return Container(
          width: columnWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: candidateItems.isNotEmpty
                ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, child) {
                  final tasks = ref.watch(provider);

                  if (tasks.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No tasks'),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _TaskCard(task: tasks[index]),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;

  const _TaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final columnWidth = MediaQuery.of(context).size.width * 0.85;

    final visualCard = Container(
      decoration: BoxDecoration(
        color: cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 20),
            color: cardTheme.color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onSelected: (newStatus) {
              updateTaskStatus(task.id, newStatus);
            },
            itemBuilder: (context) => [
              if (task.status != 'todo')
                const PopupMenuItem(
                  value: 'todo',
                  child: Text('Move to To-Do'),
                ),
              if (task.status != 'in_progress')
                const PopupMenuItem(
                  value: 'in_progress',
                  child: Text('Move to In Progress'),
                ),
              if (task.status != 'done')
                const PopupMenuItem(
                  value: 'done',
                  child: Text('Move to Done'),
                ),
            ],
          ),
        ],
      ),
    );

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        deleteTask(task.id);
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: LongPressDraggable<Task>(
        data: task,
        delay: const Duration(milliseconds: 150),
        feedback: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent,
          child: Opacity(
            opacity: 0.9,
            child: SizedBox(
              width: columnWidth,
              child: visualCard,
            ),
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: visualCard,
        ),
        child: visualCard,
      ),
    );
  }
}

class _AddTaskForm extends StatefulWidget {
  const _AddTaskForm();

  @override
  State<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<_AddTaskForm> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'NEW TASK',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'What needs to be done?',
            border: InputBorder.none,
          ),
          onSubmitted: (value) async {
            if (value.isNotEmpty) {
              await createNewTask(value);

              if (!context.mounted) return;

              Navigator.pop(context);
            }
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}