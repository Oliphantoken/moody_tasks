import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/abstract_repos/task_repository_abstract.dart';
import '../../domain/entities/task.dart';
import '../models/task_model.dart';

///Local repository implementation using SharedPreferences
class LocalTaskRepository implements TaskRepository{
  
  static const _storageKey = 'tasks_storage';

  @override
  Future<List<Task>> getTasks() async {

    //Get the shared preferences for this app from disc
    final prefs = await SharedPreferences.getInstance();

    //Get the saved data for the tasks storage space in string format 
    final prefString = prefs.getString(_storageKey);

    if(prefString == null) return [];

    //Convert string to a json object
    final List<dynamic> jsonList = jsonDecode(prefString);

    //For each element e in the jsonList,
    final tasks = jsonList.map( (e) => 

     //convert e from Map (json object) to model to entity
      TaskModel.fromMap(e).toEntity()
    )
    //Return a new list with the converted entities
    .toList();

    return tasks;
  }

  @override
  Future<void> addTask(Task task) async{

    //Get tasks list from storage
    final tasks = await getTasks();

    //Add the new task to the task list
    tasks.add(task);

    //Convert back into json
    final taskMaps = tasks.map((t) =>
      TaskModel.fromEntity(t).toMap()
    ).toList();

    //Set the tasks storage key with the updated list as value
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(taskMaps));
  }

  @override
  Future<void> updateTask(Task task) async{
    final tasks = await getTasks();
    final index = tasks.indexWhere((element) => element.id == task.id);
    if(index == -1) return;

    tasks[index] = task;

    final taskMaps = tasks.map((t) =>
      TaskModel.fromEntity(t).toMap()
    ).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(taskMaps));
  }

  @override
  Future<void> deleteTask(String id) async{
    final tasks = await getTasks();
    tasks.removeWhere((t) => t.id == id);

    final tasksMap = tasks.map((e) =>
      TaskModel.fromEntity(e).toMap()
    ).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(tasksMap));
  }

  @override
  Future<void> saveTaskOrders(List<Task> tasks){
    throw Exception('local_task_repo has not implemented saveTaskOrders yet');
  }
}