import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_app/services/task_service.dart';
import '../model/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  bool _isLoading = false;
  bool _hasMoreTasks = true;
  int _limit = 10;
  int _skip = 0;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get hasMoreTasks => _hasMoreTasks;
  Map<int, bool> _taskLoadingStates = {};

  void setTaskLoading(int taskId, bool loading) {
    _taskLoadingStates[taskId] = loading;
    notifyListeners();
  }

  bool getTaskLoading(int taskId) {
    return _taskLoadingStates[taskId] ?? false;
  }

  void updatePagination(int limit, int skip) {
    _limit = limit;
    _skip = skip;
  }

  Future<void> fetchTasks() async {
    if (!_isLoading) {
      _isLoading = true;
      try {
        _tasks = await _taskService.fetchTasks(limit: _limit, skip: _skip);
        _skip += _limit;
        _isLoading = false;
        notifyListeners();
      } catch (e) {
        print('Error fetching tasks: $e');
        _isLoading = false;
      }
    }
  }

  Future<void> fetchMoreTasks() async {
    if (!_isLoading && _hasMoreTasks) {
      _isLoading = true;
      try {
        final List<Task> newTasks =
            await _taskService.fetchTasks(limit: _limit, skip: _skip);
        if (newTasks.isEmpty) {
          _hasMoreTasks = false;
        } else {
          _tasks.addAll(newTasks);
          _skip += _limit;
        }
      } catch (e) {
        print('Error fetching more tasks: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> refreshTasks() async {
    _skip = 0;
    _hasMoreTasks = true;
    await fetchTasks();
  }

  Future<void> addTask(Task task) async {
    try {
      await _taskService.addTask(task);
      _tasks.insert(0, task); // Insert at the beginning of the list
      notifyListeners();
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  Future<void> updateTaskStatus(int taskId, bool completed) async {
    setTaskLoading(taskId, true);
    try {
      await _taskService.updateTaskStatus(taskId, completed);
      final index = _tasks.indexWhere((task) => task.id == taskId);
      if (index != -1) {
        _tasks[index].completed = completed;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating task status: $e');
      }
    } finally {
      setTaskLoading(taskId, false);
      await fetchTasks();
    }
  }

  Future<void> deleteTask(int taskId) async {
    setTaskLoading(taskId, true);
    try {
      await _taskService.deleteTask(taskId);
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      print('Error deleting task: $e');
    } finally {
      setTaskLoading(taskId, false);
      await fetchTasks();
    }
  }
}
