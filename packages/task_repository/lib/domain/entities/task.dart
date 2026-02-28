import './category.dart';
import '../value_types.dart';

class Task {
  String id;
  String title;
  String description;
  double duration;
  DateTime dueDate;
  Category category;
  Priority priority;
  Complexity complexity;
  String project;
  List<String> tags;
  TaskStatus status;
  double completionRate;
  bool isDone;
  int orderIndex;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.dueDate,
    required this.category,
    required this.priority,
    required this.complexity,
    required this.project,
    required this.tags,
    required this.status,
    required this.completionRate,
    required this.orderIndex,
    this.isDone = false,
  });

  static final empty = Task(
    id: "",
    title: "",
    description: "",
    duration: 0,
    dueDate: DateTime.now(),
    category: Category.empty,
    priority: Priority.low,
    complexity: Complexity.easy,
    project: "",
    tags: const [],
    status: TaskStatus.backlog,
    completionRate: 0.0,
    isDone: false,
    orderIndex: 0,
  );

  Task copyWith({
    String? id,
    String? title,
    String? description,
    double? duration,
    DateTime? dueDate,
    Category? category,
    Priority? priority,
    Complexity? complexity,
    String? project,
    List<String>? tags,
    TaskStatus? status,
    double? completionRate,
    bool? isDone,
    int? orderIndex,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      complexity: complexity ?? this.complexity,
      project: project ?? this.project,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      completionRate: completionRate ?? this.completionRate,
      isDone: isDone ?? this.isDone,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }

  void validate() {
    // 1. Basic required fields
    if (id.isEmpty) {
      throw ArgumentError('Task id must not be empty');
    }
    if (title.trim().isEmpty) {
      throw ArgumentError('Task title must not be empty');
    }

    // 2. Numeric ranges
    if (duration < 0) {
      throw ArgumentError('Task duration must be >= 0');
    }
    if (completionRate < 0 || completionRate > 1) {
      throw ArgumentError('Task completionRate must be between 0 and 1');
    }

    // If isDone is true, you might want completionRate == 1
    if (isDone && completionRate < 1) {
      throw ArgumentError(
        'Completed task must have completionRate == 1',
      );
    }
  }

}
