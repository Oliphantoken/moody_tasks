import 'package:sqflite/sqflite.dart';
import '../../domain/entities/task.dart';
import '../../domain/abstract_repos/task_repository_abstract.dart';
import '../models/task_model.dart';
import '../datasources/task_db_helper.dart';

class SqfliteTaskRepository implements TaskRepository {
  final TaskDbHelper _dbHelper;

  SqfliteTaskRepository({TaskDbHelper? dbHelper})
      : _dbHelper = dbHelper ?? TaskDbHelper.instance;

  @override
  Future<List<Task>> getTasks() async {
    final db = await _dbHelper.database;
    final maps = await db.query('tasks', orderBy: 'orderIndex ASC');
    final models = maps.map((map) => TaskModel.fromMap(map)).toList();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> addTask(Task task) async {
    task.validate();
    final db = await _dbHelper.database;
    final model = TaskModel.fromEntity(task);
    await db.insert('tasks', model.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateTask(Task task) async {
    task.validate();
    final db = await _dbHelper.database;
    final model = TaskModel.fromEntity(task);
    await db.update('tasks', model.toMap(), where: 'id = ?', whereArgs: [model.id]);
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _dbHelper.database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> saveTaskOrders(List<Task> tasks) async {
    final db = await _dbHelper.database;
    
    await db.transaction((txn) async {
      for (var i = 0; i < tasks.length; i++) {
        final task = tasks[i];
        final model = TaskModel.fromEntity(task.copyWith(orderIndex: i));
        
        await txn.update('tasks', model.toMap(),
                  where: 'id = ?', whereArgs: [model.id]);
      }
    });
  }

}
