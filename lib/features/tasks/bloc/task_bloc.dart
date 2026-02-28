import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_repository/domain/abstract_repos/task_repository_abstract.dart';
import 'package:task_repository/domain/entities/task.dart';

part 'task_event.dart';
part 'task_state.dart';

///Frontend state management with BloC (Our Waitress) 
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  
  TaskBloc({required this.repository}) : super(TaskInitial()) {

    ///Load tasks event handler
    on<LoadTasks>((event, emit) async{
      
      emit(TaskLoading());   
      try {
        final tasks = await repository.getTasks();
        emit(TaskSuccess(tasks: tasks, currentTaskId: ""));
      } catch (e) {
        emit(TaskFailure('Failed to load tasks: $e'));
      }
    });

    ///Add task event handler
    on<AddTask>((event, emit) async {

      emit(TaskLoading());
      try {
        await repository.addTask(event.task);
        final tasks = await repository.getTasks();
        print("added: ${event.task.title}");
        emit(TaskSuccess(tasks: tasks, currentTaskId: event.currentTaskId));
      }
      catch (e) {
        emit(TaskFailure('Failed to add task: $e'));
      }
    });

    ///Update task event handler
    on<UpdateTask>((event, emit) async{

      emit(TaskLoading());
      try {
        await repository.updateTask(event.task);
        final tasks = await repository.getTasks();
        emit(TaskSuccess(tasks: tasks, currentTaskId: event.currentTaskId));
      }
      catch (e) {
        emit(TaskFailure('Failed to update task: $e'));
      }
    });

    ///Delete task event handler
    on<DeleteTask>((event, emit) async{
      
      emit(TaskLoading());
      try {
        await repository.deleteTask(event.taskID);
        final tasks = await repository.getTasks();
        print("Deleting - emitting new TaskSuccess with ${tasks.length} tasks");
        emit(TaskSuccess(tasks:tasks, currentTaskId: event.currentTaskId));
      } 
      catch (e) {
        emit(TaskFailure('Failed to delete task: $e'));
      }

    });

    //Update the orderIndex in the tasklistscreen
    on<UpdateTaskOrder>((event, emit) async{
      emit(TaskLoading());
      try{
        //Save new order to repo
        await repository.saveTaskOrders(event.tasks);
        final tasks = await repository.getTasks();
        emit(TaskSuccess(tasks: tasks, currentTaskId: event.currentTaskId));
      }catch(e){
        emit(TaskFailure('Failed to update task order: $e'));
      }
    });

    //Set currentTaskID in the pomodoroscreen
    on<SetCurrentTask>((event, emit){
      if(state is TaskSuccess){
        emit((state as TaskSuccess).copyWith(currentTaskId: event.taskId));
      }
    });

  }
}
