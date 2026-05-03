import 'package:task_repository/data/models/category_model.dart';
import '../../domain/entities/task.dart';
import '../../domain/value_types.dart';

//For SQFLite
import 'dart:convert';

class TaskModel {
  String id;
  String title;
  String description;
  double duration;
  int dueDateMilliseconds;
  CategoryModel categoryModel;
  String priority;
  String complexity;
  String project;
  List<String> tags;
  String status;
  double completionRate;
  int isDoneInt;
  int orderIndex;

  TaskModel({    
    required this.id,
    required this.title,
    required this.description,
    required this.dueDateMilliseconds,
    required this.duration,
    required this.categoryModel,
    required this.priority,
    required this.complexity,
    required this.project,
    required this.tags,
    required this.status,
    required this.completionRate,
    required this.isDoneInt,
    required this.orderIndex,
  });


  /// Convert from SQFLite DB Map row to model
  factory TaskModel.fromMap(Map<String, dynamic> map) {

  //Data validations
    if (map['id'] == null || (map['id'] as String).isEmpty) {
      throw FormatException('Task row missing id');
    }
    if (map['title'] == null || (map['title'] as String).isEmpty) {
      throw FormatException('Task row missing title');
    }

    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      duration: (map['duration'] as num).toDouble(),
      dueDateMilliseconds: map['duDateMilliseconds'] as int,
      categoryModel: CategoryModel.fromMap(
        jsonDecode(map['categoryModel'] as String) as Map<String, dynamic>,
      ),
      priority: map['priority'] as String,
      complexity: map['complexity'] as String,
      project: map['project'] as String,
      tags: List<String>.from(jsonDecode(map['tags'] as String)),
      status: map['status'] as String,
      completionRate: (map['completionRate'] as num).toDouble(),
      isDoneInt: map['isDoneInt'] as int,
      orderIndex: map['orderIndex'] ?? 0,
    );
  }

  ///Convert from model to Map (jsonEncode for SQFLite DB)
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'duDateMilliseconds': dueDateMilliseconds,
      'categoryModel': jsonEncode(categoryModel.toMap()), //categoryModel.toMap(),
      'priority': priority,
      'complexity': complexity,
      'project': project,
      'tags': jsonEncode(tags), //tags
      'status': status,
      'completionRate': completionRate,
      'isDoneInt': isDoneInt,
      'orderIndex': orderIndex,
    };
  }

  ///Convert from entity to model
  factory TaskModel.fromEntity(Task task){
    return TaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      duration: task.duration,
      dueDateMilliseconds: task.dueDate.microsecondsSinceEpoch,
      categoryModel: CategoryModel.fromEntity(task.category),
      priority: task.priority.displayName,
      complexity: task.complexity.displayName,
      project: task.project,
      tags: task.tags,
      status: task.status.displayName,
      completionRate: task.completionRate,
      isDoneInt: task.isDone ? 1 : 0,
      orderIndex: task.orderIndex
    );
  }
  
  ///Convert from model to entity
  Task toEntity(){
    return Task(
      id: id,
      title: title,
      description: description,
      duration: duration,
      dueDate: DateTime.fromMicrosecondsSinceEpoch(dueDateMilliseconds),
      category: categoryModel.toEntity(),
      priority: PriorityExtension.fromString(priority),
      complexity: ComplexityExtension.fromString(complexity),
      project: project,
      tags: tags,
      status: TaskStatusExtension.fromString(status),
      completionRate: completionRate,
      isDone: isDoneInt == 1,
      orderIndex: orderIndex,
    );
  }

}
