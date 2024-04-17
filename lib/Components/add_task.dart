import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import '../Model/model.dart';
import '../Provider/task_provider.dart';

class AddTaskForm extends StatefulWidget {
  final Task? initialTask;

  const AddTaskForm({Key? key, this.initialTask}) : super(key: key);

  @override
  _AddTaskFormState createState() => _AddTaskFormState();
}

class _AddTaskFormState extends State<AddTaskForm> {

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  String? titleError;
  String? descriptionError;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers and pre-fill with initial task details if provided
    titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    descriptionController = TextEditingController(text: widget.initialTask?.description ?? '');
  }

  @override
  void dispose() {
    // Dispose text controllers to avoid memory leaks
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void addTask(TaskProvider taskProvider) async {
    // Get title and description from text controllers
    final String title = titleController.text;
    final String description = descriptionController.text;

    // Check if title or description is empty
    if (title.isEmpty || description.isEmpty) {
      // Set error messages if fields are empty
      setState(() {
        titleError = title.isEmpty ? 'Please enter a title' : null;
        descriptionError = description.isEmpty ? 'Please enter a description' : null;
      });
      return;
    }

    // Create a new task object
    final Task task = Task(title: title, description: description);
    // Add task to the provider
    taskProvider.addTask(task);

    // Show a toast message indicating task added successfully
    showToast('Task added successfully',
        context: context,
        backgroundColor: Colors.green,
        textStyle: const TextStyle(color: Colors.white),
        animation: StyledToastAnimation.fade,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 2));

    // Close the add task screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTask == null ? "Add Task" : 'Update Task'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // task title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    errorText: titleError, // Show error text if title is empty
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // task description
                TextField(
                  minLines: 2,
                  maxLines: 5,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Task Description',
                    errorText: descriptionError, // Show error text if description is empty
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                // add task
                ElevatedButton(
                  onPressed: () {
                    addTask(taskProvider); // Add task to provider when button is pressed
                  },
                  child: Text(widget.initialTask == null ? "Add Task" : 'Update Task'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

