import 'dart:io';
import 'dart:convert';

class Task {
  String title;
  String description;
  bool isComplete;

  Task(this.title, this.description, this.isComplete);

  // Convert Task object to JSON
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'isComplete': isComplete,
      };

  // Create a Task object from JSON
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        isComplete = json['isComplete'];
}

class TaskManager {
  List<Task> tasks = [];

  // Load tasks from JSON file
  void loadTasks() {
    final file = File('tasks.json');
    if (file.existsSync()) {
      try {
        String fileContent = file.readAsStringSync();
        if (fileContent.isNotEmpty) {
          List<dynamic> jsonTasks = jsonDecode(fileContent);
          tasks = jsonTasks.map((json) => Task.fromJson(json)).toList();
          print("Tasks loaded from file.");
        } else {
          print("The file is empty, no tasks to load.");
        }
      } catch (e) {
        print("Error loading tasks: $e");
      }
    } else {
      print("No saved tasks found.");
    }
  }

  // Save tasks to JSON file
  void saveTasks() {
    try {
      final file = File('tasks.json');
      List<Map<String, dynamic>> jsonTasks =
          tasks.map((task) => task.toJson()).toList();
      file.writeAsStringSync(jsonEncode(jsonTasks));
      print("Tasks saved to file.");
    } catch (e) {
      print("Error saving tasks: $e");
    }
  }

  void addTask(String title, String description, bool isComplete) {
    tasks.add(Task(title, description, isComplete));
    saveTasks();
  }

  void updateTask(
      int index, String title, String description, bool isComplete) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].title = title;
      tasks[index].description = description;
      tasks[index].isComplete = isComplete;
      saveTasks();
      print("Task updated successfully.");
    } else {
      print("Invalid index.");
    }
  }

  void deleteTask(int index) {
    if (index >= 0 && index < tasks.length) {
      tasks.removeAt(index);
      saveTasks();
      print("Task deleted successfully.");
    } else {
      print("Invalid index.");
    }
  }

  void displayTasks() {
    if (tasks.isEmpty) {
      print("No tasks found.");
    } else {
      for (int i = 0; i < tasks.length; i++) {
        print(
            'Task ${i + 1}: ${tasks[i].title} - ${tasks[i].description} - Complete: ${tasks[i].isComplete}');
      }
    }
  }

  void displayCompletedTasks() {
    tasks.where((task) => task.isComplete).forEach((task) {
      print(
          '${task.title} - ${task.description} - Complete: ${task.isComplete}');
    });
  }

  void displayIncompleteTasks() {
    tasks.where((task) => !task.isComplete).forEach((task) {
      print(
          '${task.title} - ${task.description} - Complete: ${task.isComplete}');
    });
  }

  void changeStatus(int index, bool isComplete) {
    if (index >= 0 && index < tasks.length) {
      tasks[index].isComplete = isComplete;
      saveTasks();
      print("Status updated successfully.");
    } else {
      print("Invalid index.");
    }
  }
}

void displayMenu() {
  print('___________________________________________________________');
  print('|    Select Your Choice                                    |');
  print('| [1] Add New Task          [2] Update Task               |');
  print('| [3] Delete Task           [4] List All Tasks            |');
  print('| [5] List Completed Tasks  [6] List Incomplete Tasks     |');
  print('| [7] Change Status         [8] Exit                      |');
  print('___________________________________________________________');
}

void main() {
  TaskManager taskManager = TaskManager();
  taskManager.loadTasks();

  while (true) {
    displayMenu();
    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        print("Enter Task Title:");
        String? title = stdin.readLineSync() ?? 'Untitled';
        print("Enter Task Description:");
        String? description = stdin.readLineSync() ?? 'No description';
        print("Enter Task Status (1 for complete, 0 for incomplete):");
        int? status = int.tryParse(stdin.readLineSync() ?? '');
        if (status == 1 || status == 0) {
          taskManager.addTask(title, description, status == 1);
        } else {
          print("Invalid status entered.");
        }
        break;
      case 2:
        print("Enter Task Index to Update:");
        int? index = int.tryParse(stdin.readLineSync() ?? '');
        if (index != null && index > 0 && index <= taskManager.tasks.length) {
          print("Enter New Title:");
          String title = stdin.readLineSync() ?? 'Untitled';
          print("Enter New Description:");
          String description = stdin.readLineSync() ?? 'No description';
          print("Enter New Status (1 for complete, 0 for incomplete):");
          int? status = int.tryParse(stdin.readLineSync() ?? '');
          if (status == 1 || status == 0) {
            taskManager.updateTask(index - 1, title, description, status == 1);
          } else {
            print("Invalid status entered.");
          }
        } else {
          print("Invalid index.");
        }
        break;
      case 3:
        print("Enter Task Index to Delete:");
        int? index = int.tryParse(stdin.readLineSync() ?? '');
        if (index != null && index > 0 && index <= taskManager.tasks.length) {
          taskManager.deleteTask(index - 1);
        } else {
          print("Invalid index.");
        }
        break;
      case 4:
        taskManager.displayTasks();
        break;
      case 5:
        print("Completed Tasks:");
        taskManager.displayCompletedTasks();
        break;
      case 6:
        print("Incomplete Tasks:");
        taskManager.displayIncompleteTasks();
        break;
      case 7:
        print("Enter Task Index to Change Status:");
        int? index = int.tryParse(stdin.readLineSync() ?? '');
        if (index != null && index > 0 && index <= taskManager.tasks.length) {
          print("Enter New Status (1 for complete, 0 for incomplete):");
          int? status = int.tryParse(stdin.readLineSync() ?? '');
          if (status == 1 || status == 0) {
            taskManager.changeStatus(index - 1, status == 1);
          } else {
            print("Invalid status entered.");
          }
        } else {
          print("Invalid index.");
        }
        break;
      case 8:
        print("Exiting Program.");
        exit(0);
      default:
        print("Invalid choice. Please select a valid option.");
    }
  }
}
