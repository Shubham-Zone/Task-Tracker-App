import 'dart:convert';

class Task {
  String title;
  String description;
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  static List<String> tasksToJson(List<Task> tasks) {
    List<String> jsonList = [];
    for (var task in tasks) {
      jsonList.add(task.toJson());
    }
    return jsonList;
  }

  static List<Task> tasksFromJson(List<String> jsonList) {
    List<Task> tasks = [];
    for (var jsonString in jsonList) {
      tasks.add(Task.fromJson(jsonString));
    }
    return tasks;
  }

  String toJson() {
    return jsonEncode({
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    });
  }

  factory Task.fromJson(String jsonString) {
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return Task(
      title: jsonMap['title'] ?? '',
      description: jsonMap['description'] ?? '',
      isCompleted: jsonMap['isCompleted'] ?? false,
    );
  }
}