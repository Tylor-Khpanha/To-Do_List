import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/controller/app_colors.dart';
import 'package:todolist/controller/controler_lish.dart';
import 'package:todolist/screan/add_task_screen.dart';

class Task {
  String title;
  DateTime? dateTime;
  bool isDone;
  String category;
  String description;

  Task(this.title,
      {this.dateTime,
      this.isDone = false,
      this.category = 'All',
      this.description = ''});

  Map<String, dynamic> toJson() => {
        'title': title,
        'dateTime': dateTime?.toIso8601String(),
        'isDone': isDone,
        'category': category,
        'description': description,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        json['title'],
        dateTime:
            json['dateTime'] != null ? DateTime.parse(json['dateTime']) : null,
        isDone: json['isDone'] ?? false,
        category: json['category'] ?? 'All',
        description: json['description'] ?? '',
      );
}

class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'តារាងកិច្ចការ',
          style: TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 20,
            color: AppColor.tertiaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => DropdownMenu<String>(
                    initialSelection: taskController.selectedCategory.value,
                    onSelected: (String? value) {
                      if (value != null) {
                        taskController.updateCategory(value);
                      }
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry<String>(
                        value: 'All',
                        label: 'ទាំងអស់',
                      ),
                      DropdownMenuEntry<String>(
                        value: 'Study',
                        label: 'ការសិក្សា',
                      ),
                      DropdownMenuEntry<String>(
                        value: 'Assignment',
                        label: 'កិច្ចការកំណត់',
                      ),
                      DropdownMenuEntry<String>(
                        value: 'Exam',
                        label: 'ប្រលង',
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      'រួចរាល់',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kantumruy Pro',
                      ),
                    ),
                    Obx(
                      () => Switch(
                        value: taskController.showCompleted.value,
                        onChanged: (value) {
                          taskController.toggleShowCompleted(value);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                var filteredTasks = taskController.filteredTasks;
                if (filteredTasks.isEmpty) {
                  return Center(
                    child: Text(
                      taskController.showCompleted.value
                          ? 'មិនទាន់មានកិច្ចការរួចរាល់'
                          : 'មិនទាន់មានកិច្ចការ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.black,
                        fontFamily: 'Kantumruy Pro',
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 15,
                      ),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ចំណងជើង: ${task.title}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          if (task.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'ការពិពណ៌នា: ${task.description}',
                              ),
                            ),
                          if (task.dateTime != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'កាលបរិច្ឆេទកំណត់: ${DateFormat('yyyy-MM-dd').format(task.dateTime!)}',
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check_circle,
                                    color: task.isDone
                                        ? AppColor.secondaryColor
                                        : AppColor.disable),
                                onPressed: () =>
                                    taskController.toggleTaskStatus(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    taskController.removeTask(index),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Get.to(() => AddTaskScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
