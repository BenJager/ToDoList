class Task {
  final String title;
  bool completed;

  Task(this.title, {this.completed = false});

  Map<String, dynamic> toJson() => {
    'title': title,
    'completed': completed,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    json['title'],
    completed: json['completed'],
  );
}