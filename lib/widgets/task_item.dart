import 'package:flutter/material.dart';

import '../model/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(bool?)? onTaskCompletion;
  final Function()? onTaskDeletion;

  const TaskItem({
    super.key,
    required this.task,
    this.onTaskCompletion,
    this.onTaskDeletion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task.todo),
        leading: Checkbox(
          value: task.completed,
          onChanged: onTaskCompletion,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(context);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Delete"),
              onPressed: () {
                if (onTaskDeletion != null) {
                  onTaskDeletion!();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
