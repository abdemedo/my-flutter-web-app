// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(TaskMasterApp());
}

class TaskMasterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TaskHomePage(),
    );
  }
}

class TaskHomePage extends StatefulWidget {
  @override
  _TaskHomePageState createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  List<Map<String, dynamic>> tasks = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedPriority = 'Normal';
  List<Map<String, dynamic>> filteredTasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedTasks = prefs.getString('tasks');
    if (savedTasks != null) {
      setState(() {
        tasks = List<Map<String, dynamic>>.from(json.decode(savedTasks));
        filteredTasks = tasks;
      });
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', json.encode(tasks));
  }

  void _addTask(String title, String description, String priority) {
    setState(() {
      tasks.add({
        'title': title,
        'description': description,
        'priority': priority,
        'isCompleted': false,
      });
      filteredTasks = tasks;
    });
    _saveTasks();
    _titleController.clear();
    _descriptionController.clear();
    Navigator.of(context).pop();
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['isCompleted'] = !tasks[index]['isCompleted'];
      filteredTasks = tasks;
    });
    _saveTasks();
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
      filteredTasks = tasks;
    });
    _saveTasks();
  }

  void _searchTasks(String query) {
    setState(() {
      filteredTasks = tasks
          .where((task) => task['title']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openAddTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(hintText: 'Task Title'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: 'Task Description'),
                ),
                SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  items: ['High', 'Normal', 'Low']
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPriority = value ?? 'Normal';
                    });
                  },
                  decoration: InputDecoration(labelText: 'Priority'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Add Task'),
              onPressed: () {
                _addTask(
                  _titleController.text,
                  _descriptionController.text,
                  _selectedPriority,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TaskMaster'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TaskSearchDelegate(tasks),
              );
            },
          ),
        ],
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (context, index) {
            final task = filteredTasks[index];
            return ListTile(
              title: Text(task['title']),
              subtitle: Text(
                  '${task['description']}\nPriority: ${task['priority']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: task['isCompleted'],
                    onChanged: (_) => _toggleTaskCompletion(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _openAddTaskDialog,
      ),
    );
  }
}

class TaskSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> tasks;

  TaskSearchDelegate(this.tasks);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = tasks
        .where((task) => task['title']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final task = results[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = tasks
        .where((task) => task['title']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final task = suggestions[index];
        return ListTile(
          title: Text(task['title']),
          subtitle: Text(task['description']),
        );
      },
    );
  }
}
