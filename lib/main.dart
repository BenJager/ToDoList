import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task.dart';
import 'task_input.dart';
import 'task_list.dart';

void main() {
  runApp(const MyApp());
}

const String _tasksKey = 'tasks';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liste de tâches',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const MyHomePage(title: 'ToDoList'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> _tasks = [];
  final TextEditingController _controller = TextEditingController();
  late final SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    _prefs = await SharedPreferences.getInstance();
    final tasksJson = _prefs.getStringList(_tasksKey);
    if (tasksJson != null) {
      setState(() {
        _tasks.addAll(tasksJson.map((json) => Task.fromJson(jsonDecode(json))));
      });
    }
  }

  Future<void> _saveTasks() async {
    await _prefs.setStringList(
      _tasksKey,
      _tasks.map((task) => jsonEncode(task.toJson())).toList(),
    );
  }

  void _ajouterTache() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _tasks.add(Task(_controller.text));
        _controller.clear();
        _saveTasks();
      }
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.completed = !task.completed;
      _saveTasks();
    });
  }

  Future<void> _confirmDelete() async {
    final completedCount = _tasks.where((t) => t.completed).length;
    if (completedCount == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: Text('Supprimer $completedCount tâche(s) complétée(s) ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Non'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _tasks.removeWhere((task) => task.completed);
        _saveTasks();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TaskInput(
            controller: _controller,
            onAdd: _ajouterTache,
          ),
          Expanded(
            child: TaskList(
              tasks: _tasks,
              onTaskToggle: _toggleTask,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _confirmDelete,
        tooltip: 'Supprimer les tâches complétées',
        child: const Icon(Icons.delete),
      ),
    );
  }
}
