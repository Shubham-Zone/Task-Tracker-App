import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'Components/add_task.dart'; // Importing the AddTask widget
import 'Model/model.dart'; // Importing the Task model
import 'Provider/task_provider.dart'; // Importing the TaskProvider

void main() {
  runApp(const TaskTrackerApp());
}

class TaskTrackerApp extends StatelessWidget {
  const TaskTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(), // Create a TaskProvider instance
      child: MaterialApp(
        title: 'Task Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TaskTrackerScreen(),
      ),
    );
  }
}

class TaskTrackerScreen extends StatelessWidget {
  const TaskTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 600),
              pageBuilder: (context, animation, secondaryAnimation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: const AddTaskForm(),
                );
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          List<Task> tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/empty.png",
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "No task is added ):",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    title: Text(
                      tasks[index].title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: tasks[index].isCompleted ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      tasks[index].description,
                      style: TextStyle(
                        fontSize: 16,
                        color: tasks[index].isCompleted ? Colors.grey : Colors.black54,
                      ),
                    ),
                    leading: Checkbox(
                      value: tasks[index].isCompleted,
                      onChanged: (value) {
                        taskProvider.updateTask(index, Task(
                          title: tasks[index].title,
                          description: tasks[index].description,
                          isCompleted: value ?? false,
                        ));
                      },
                    ),
                    // Add edit and delete buttons as a PopupMenuButton
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit, color: Colors.blue),
                            title: Text('Edit'),
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: Colors.red),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskForm(
                                initialTask: tasks[index], // Pass task details for editing
                              ),
                            ),
                          );
                        } else if (value == 'delete') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: Text('Are you sure you want to delete ${tasks[index].title} task?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                      showToast(
                                        '${tasks[index].title} task is deleted successfully',
                                        context: context,
                                        backgroundColor: Colors.blue,
                                        animation: StyledToastAnimation.scale,
                                        reverseAnimation: StyledToastAnimation.fade,
                                        position: StyledToastPosition.center,
                                        animDuration: const Duration(seconds: 1),
                                        duration: const Duration(seconds: 4),
                                        curve: Curves.elasticOut,
                                        reverseCurve: Curves.linear,
                                      );
                                      taskProvider.deleteTask(index);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                );

              },
            );
          }
        },
      ),
    );
  }
}

