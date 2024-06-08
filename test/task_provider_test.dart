import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/model/task_model.dart';
import 'package:task_manager_app/providers/task_provider.dart';

void main() {
  group('Task Provider', () {
    late TaskProvider taskProvider;

    setUp(() {
      taskProvider = TaskProvider();
    });

    test('Fetch tasks', () async {
      await taskProvider.fetchTasks();
      expect(taskProvider.tasks.isNotEmpty, true);
    });

    test('Add task', () async {
      final newTask =
          Task(id: 101, todo: 'Test Task', completed: false, userId: 1);
      await taskProvider.addTask(newTask);
      expect(taskProvider.tasks.any((task) => task.id == 101), true);
    });

    test('Update task', () async {
      final updatedTask =
          Task(id: 1, todo: 'Updated Task', completed: true, userId: 1);
      await taskProvider.updateTaskStatus(
          updatedTask.id, updatedTask.completed);
      final updatedTaskInList =
          taskProvider.tasks.firstWhere((task) => task.id == 1);
      expect(updatedTaskInList.todo, 'Updated Task');
      expect(updatedTaskInList.completed, true);
    });

    test('Delete task', () async {
      await taskProvider.deleteTask(1);
      expect(taskProvider.tasks.any((task) => task.id == 1), false);
    });
  });
}
