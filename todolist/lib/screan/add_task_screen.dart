import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todolist/controller/app_colors.dart';
import 'package:todolist/controller/controler_lish.dart';

class AddTaskScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString selectedCategory = 'All'.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ការបន្ថែមកិច្ចការ',
          style: TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 20,
            color: AppColor.tertiaryColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'ចំណងជើង',
                hintStyle: TextStyle(color: AppColor.secondaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: AppColor.tertiaryColor),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'ការពិពណ៌នា',
                hintStyle: TextStyle(color: AppColor.secondaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: AppColor.tertiaryColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            // Category Dropdown
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.tertiaryColor),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(
                () => DropdownButton<String>(
                  value: selectedCategory.value,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: 'All',
                      child: Text('ទាំងអស់'),
                    ),
                    DropdownMenuItem(
                      value: 'Study',
                      child: Text('ការសិក្សា'),
                    ),
                    DropdownMenuItem(
                      value: 'Assignment',
                      child: Text('ការងារកំណត់'),
                    ),
                    DropdownMenuItem(
                      value: 'Exam',
                      child: Text('ប្រលង'),
                    ),
                  ],
                  // .map((category) => DropdownMenuItem(
                  //       value: category,
                  //       child: Text(category),
                  //     ))
                  // .toList(),
                  onChanged: (value) {
                    selectedCategory.value = value!;
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDate.value != null
                          ? 'កាលបរិច្ឆេទកំណត់: ${DateFormat('yyyy-MM-dd').format(selectedDate.value!)}'
                          : 'គ្មានកាលបរិច្ឆេទកំណត់',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Kantumruy Pro',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          selectedDate.value = pickedDate;
                        }
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (titleController.text.isEmpty) {
                  Get.snackbar(
                    'មិនត្រឹមត្រូវ',
                    'ចំណងជើងមិនអាចអត់មានទេ!',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }
                taskController.addTask(
                  titleController.text,
                  category: selectedCategory.value,
                  description: descriptionController.text,
                  dateTime: selectedDate.value,
                );
                Get.back();
              },
              child: const Text(
                'បន្ថែមកិច្ចការ',
                style: TextStyle(
                  fontFamily: 'Kantumruy Pro',
                  fontSize: 16,
                  color: AppColor.inverted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
