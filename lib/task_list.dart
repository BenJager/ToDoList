import 'package:flutter/material.dart';
import 'task.dart';

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onTaskToggle;

  const TaskList({
    super.key,
    required this.tasks,
    required this.onTaskToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: CheckboxListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed 
                  ? TextDecoration.lineThrough 
                  : TextDecoration.none,
              ),
            ),
            value: task.completed,
            onChanged: (value) => onTaskToggle(task),
            secondary: Icon(
              task.completed ? Icons.check_circle : Icons.circle_outlined,
              color: task.completed ? Colors.green : Colors.grey,
            ),
          ),
        );
      },
    );
  }
}