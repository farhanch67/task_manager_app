import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchTasks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.position.pixels;
    final double percentage = currentScroll / maxScroll;

    // Adjust the threshold value as needed
    if (percentage > 0.8 &&
        taskProvider.hasMoreTasks &&
        !taskProvider.isLoading) {
      // Calculate new skip value
      int newSkip = taskProvider.tasks.length;
      // Adjust the limit as needed
      int newLimit = 10; // Or any other value you want to use

      taskProvider.updatePagination(newLimit, newSkip);
      taskProvider.fetchMoreTasks();
    }
  }

  Future<void> _fetchTasks() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    await taskProvider.fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: RefreshIndicator(
        onRefresh: () async {
          final taskProvider =
          Provider.of<TaskProvider>(context, listen: false);
          await taskProvider.refreshTasks();
        },
        child: ListView.builder(
          controller: _scrollController,
          itemCount:
          taskProvider.tasks.length + (taskProvider.hasMoreTasks ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < taskProvider.tasks.length) {
              return TaskItem(
                task: taskProvider.tasks[index],
                onTaskCompletion: (bool? status) {
                  _updateTaskStatus(context, taskProvider, index, status);
                },
                onTaskDeletion: () {
                  _deleteTask(context, taskProvider, index);
                },
              );
            } else if (taskProvider.hasMoreTasks) {
              return _buildLoader();
            } else {
              return const SizedBox(); // Return an empty container when no more tasks to load
            }
          },
        ),
      ),
    );
  }

  void _updateTaskStatus(BuildContext context, TaskProvider taskProvider, int index, bool? status) async {
    final taskId = taskProvider.tasks[index].id;
    taskProvider.setTaskLoading(taskId, true);
    await taskProvider.updateTaskStatus(taskId, status ?? false);
    taskProvider.setTaskLoading(taskId, false);
  }

  void _deleteTask(BuildContext context, TaskProvider taskProvider, int index) async {
    final taskId = taskProvider.tasks[index].id;
    taskProvider.setTaskLoading(taskId, true);
    await taskProvider.deleteTask(taskId);
    taskProvider.setTaskLoading(taskId, false);
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
