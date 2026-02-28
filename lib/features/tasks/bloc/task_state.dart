part of 'task_bloc.dart';

sealed class TaskState extends Equatable {
  const TaskState();
  
  @override
  List<Object> get props => [];
}

final class TaskInitial extends TaskState {}
final class TaskLoading extends TaskState {}

final class TaskFailure extends TaskState {
  final String errorMessage;
  const TaskFailure([this.errorMessage = 'An unknown error occurred']);
  
  @override
  List<Object> get props => [errorMessage];
}

final class TaskSuccess extends TaskState {
  final List<Task> tasks;
  final String currentTaskId;

  const TaskSuccess({
    required this.tasks,
    required this.currentTaskId
  });

  TaskSuccess copyWith({
    List<Task>? tasks,
    String? currentTaskId,
  }){
    return TaskSuccess(
      tasks: tasks ?? this.tasks,
      currentTaskId: currentTaskId ?? this.currentTaskId
    );
  }

  @override
  List<Object> get props => [tasks, currentTaskId];
}
