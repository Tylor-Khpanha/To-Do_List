import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todolist/screan/task_screen.dart';

class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var selectedCategory = 'All'.obs;
  var showCompleted = false.obs;

  List<Task> get filteredTasks {
    return tasks.where((task) {
      // Filter by category
      final matchesCategory = selectedCategory.value == 'All' ||
          task.category == selectedCategory.value;

      // Filter by completion status
      final matchesCompletion =
          showCompleted.value ? task.isDone : !task.isDone;

      return matchesCategory && matchesCompletion;
    }).toList();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  void toggleShowCompleted(bool value) {
    showCompleted.value = value;
  }

  void toggleTaskStatus(int index) {
    tasks[index].isDone = !tasks[index].isDone;
    tasks.refresh();
    saveTasksToFile();
  }

  void removeTask(int index) {
    tasks.removeAt(index);
    saveTasksToFile();
  }

  @override
  void onInit() {
    super.onInit();
    loadTasksFromFile();
  }

  // void addTask(String title, DateTime? dateTime) {
  //   if (title.isEmpty) return;
  //   tasks.add(Task(title, dateTime: dateTime));
  //   saveTasksToFile();
  // }
  void addTask(String title,
      {String category = 'All', String description = '', DateTime? dateTime}) {
    if (title.isEmpty) return;
    tasks.add(Task(title,
        category: category, description: description, dateTime: dateTime));
    saveTasksToFile();
  }

  // void removeTask(int index) {
  //   tasks.removeAt(index);
  //   saveTasksToFile();
  // }

  // void toggleTaskStatus(int index) {
  //   var task = tasks[index];
  //   task.isDone = !task.isDone;
  //   tasks[index] = task;
  //   saveTasksToFile();
  // }

  // void updateCategory(String category) {
  //   selectedCategory.value = category;
  // }

  // void toggleShowCompleted(bool value) {
  //   showCompleted.value = value;
  // }

  Future<void> saveTasksToFile() async {
    final file = await _getLocalFile();
    List<Map<String, dynamic>> jsonTasks =
        tasks.map((task) => task.toJson()).toList();
    await file.writeAsString(jsonEncode(jsonTasks));
  }

  Future<void> loadTasksFromFile() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        String contents = await file.readAsString();
        List<dynamic> jsonTasks = jsonDecode(contents);
        tasks.value = jsonTasks.map((json) => Task.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  Future<File> _getLocalFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/tasks.json');
  }
}
