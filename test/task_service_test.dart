import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/model/task_model.dart';
import 'package:task_manager_app/services/task_service.dart';

void main() {
  group('Task Service', () {
    late TaskService taskService;

    setUp(() {
      taskService = TaskService();
    });

    test('Fetch tasks', () async {
      final tasks = await taskService.fetchTasks();
      expect(tasks.isNotEmpty, true);
    });

    test('Add task', () async {
      final newTask = Task(id: 101, todo: 'Test Task', completed: false, userId: 1);
      await taskService.addTask(newTask);
      final tasks = await taskService.fetchTasks();
      expect(tasks.any((task) => task.id == 101), true);
    });

    test('Update task', () async {
      final updatedTask = Task(id: 1, todo: 'Updated Task', completed: true, userId: 1);
      await taskService.updateTaskStatus(updatedTask.id,updatedTask.completed);
      final tasks = await taskService.fetchTasks();
      final updatedTaskInList = tasks.firstWhere((task) => task.id == 1);
      expect(updatedTaskInList.todo, 'Updated Task');
      expect(updatedTaskInList.completed, true);
    });

    test('Delete task', () async {
      await taskService.deleteTask(1);
      final tasks = await taskService.fetchTasks();
      expect(tasks.any((task) => task.id == 1), false);
    });
  });
}
