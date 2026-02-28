import '../../domain/abstract_repos/task_repository_abstract.dart';
import '../../domain/entities/task.dart';


//Mock class
class MockTaskRepository implements TaskRepository {
  final List<Task> _tasks = [];

  Future<void> addTasksFromMockData(List<Task> tasklistMockData) async {
    _tasks.addAll(tasklistMockData);
  }

  @override
  Future<void> addTask(Task task) async {
    _tasks.add(task);
  }

  @override
  Future<List<Task>> getTasks() async {
    return _tasks;
  }

  @override
  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((element) => element.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((element) => element.id == taskId);
  }
  
  @override
  Future<void> saveTaskOrders(List<Task> tasks){
    throw Exception('mock_repo has not implemented saveTaskOrders yet');
  }

}