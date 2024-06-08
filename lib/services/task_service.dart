import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/task_model.dart';

class TaskService {
  static const String _baseUrl = 'https://dummyjson.com/todos';

  Future<List<Task>> fetchTasks({int limit = 10, int skip = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit&skip=$skip'),
      headers: {'Content-Type': 'application/json'},
    );

    print("response is ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> todos = responseData['todos'];
      final List<Task> tasks =
          todos.map((json) => Task.fromJson(json)).toList();
      return tasks;
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<void> addTask(Task task) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add task');
    }
  }


  Future<void> updateTaskStatus(int taskId, bool completed) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'completed': completed}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update task status');
    }
  }

  Future<void> deleteTask(int taskId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$taskId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }

}
