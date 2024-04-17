import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/model.dart';

class TaskProvider extends ChangeNotifier {

  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tasks = Task.tasksFromJson(prefs.getStringList('tasks') ?? []);
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    saveTasks();
  }

  Future<void> deleteTask(int index) async {
    _tasks.removeAt(index);
    saveTasks();
  }

  Future<void> updateTask(int index, Task task) async {
    _tasks[index] = task;
    saveTasks();
  }

  Future<void> saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', Task.tasksToJson(_tasks));
    notifyListeners();
  }
}
