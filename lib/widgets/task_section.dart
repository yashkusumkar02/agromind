import 'package:agromind/widgets/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/TaskController/TaskController.dart';

class TaskSection extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                _showAddTaskDialog(context);
              },
              icon: Icon(Icons.add, color: Colors.green, size: 20),
              label: Text(
                "Add Task",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            Text(
              "Today's Tasks",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        Container(width: double.infinity, height: 2, color: Colors.green),
        const SizedBox(height: 10),

        // ✅ Show Tasks from Firestore
        Obx(() {
          if (controller.tasks.isEmpty) {
            return Center(
              child: Text(
                "No tasks added yet!",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            );
          }
          return Column(
            children: controller.tasks
                .map((task) => _buildTaskCard(task, context, UniqueKey()))
                .toList(),
          );
        }),
      ],
    );
  }

  void _showEditTaskDialog(BuildContext context, Task task) {
    TextEditingController nameController = TextEditingController(text: task.name);
    String updatedPriority = task.priority;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Task Name"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: updatedPriority,
                items: ["High", "Medium", "Low"]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) updatedPriority = value;
                },
                decoration: InputDecoration(labelText: "Priority"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                controller.updateTask(
                  task,
                  nameController.text,
                  task.startTime,
                  task.endTime,
                  updatedPriority,
                );
                Get.back();
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context, Key key) {
    return Dismissible(
      key: key, // ✅ Ensure unique key
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.edit, color: Colors.white),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _showEditTaskDialog(context, task);
          return false;
        } else if (direction == DismissDirection.endToStart) {
          return await _confirmDeleteDialog(context, task);
        }
        return false;
      },
      child: Card(
        child: ListTile(
          leading: _priorityIcon(task.priority), // ✅ Priority Icon
          title: Text(task.name),
          subtitle: Text("${task.startTime} - ${task.endTime} | ${task.priority}"),
          trailing: Icon(Icons.check_circle, color: Colors.green),
        ),
      ),
    );
  }

  /// ✅ Priority-wise Icons
  Widget _priorityIcon(String priority) {
    switch (priority) {
      case "High":
        return Icon(Icons.warning, color: Colors.red); // 🔴 High Alert
      case "Medium":
        return Icon(Icons.priority_high, color: Colors.orange); // 🟠 Medium Alert
      case "Low":
      default:
        return Icon(Icons.notifications, color: Colors.green); // 🟢 Basic Alert
    }
  }

  /// ✅ Confirm Delete Dialog
  Future<bool> _confirmDeleteDialog(BuildContext context, Task task) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure you want to delete '${task.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel", style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTask(task); // ✅ Call deleteTask from controller
              Navigator.of(context).pop(true);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }


  /// ✅ Select Date & Time Picker
  Future<void> _selectDateTime(BuildContext context, Function(DateTime) onDateTimeSelected) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate == null) return;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // ✅ Combine Date & Time
    DateTime selectedDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onDateTimeSelected(selectedDateTime);
  }

  // ✅ Add Task Dialog
  void _showAddTaskDialog(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();
    DateTime selectedDateTime = DateTime.now();
    String selectedPriority = "Medium"; // Default priority

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(labelText: "Task Name"),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                items: ["High", "Medium", "Low"]
                    .map((priority) => DropdownMenuItem(
                  value: priority,
                  child: Text(priority),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedPriority = value;
                },
                decoration: InputDecoration(labelText: "Priority"),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _selectDateTime(context, (DateTime newDateTime) {
                    selectedDateTime = newDateTime;
                  });
                },
                child: Text("Select Reminder Time"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (taskNameController.text.isNotEmpty) {
                  String selectedTime =
                      "${selectedDateTime.hour}:${selectedDateTime.minute} ${selectedDateTime.hour < 12 ? 'AM' : 'PM'}";

                  controller.addTask(Task(
                    id: "",
                    name: taskNameController.text,
                    startTime: selectedTime,
                    endTime:
                    "${selectedDateTime.hour + 1}:${selectedDateTime.minute} ${selectedDateTime.hour + 1 < 12 ? 'AM' : 'PM'}",
                    priority: selectedPriority, // ✅ Use selected priority
                    reminderTime: selectedDateTime.toIso8601String(),
                  ));
                  Get.back();
                } else {
                  Get.snackbar("Error", "Task name and reminder time cannot be empty");
                }
              },
              child: Text("Add Task"),
            ),
          ],
        );
      },
    );
  }
}
