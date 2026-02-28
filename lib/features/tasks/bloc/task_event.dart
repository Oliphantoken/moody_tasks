part of 'task_bloc.dart';

///What the user/UIs can ask for from an event
sealed class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent{
  const LoadTasks();
}

class AddTask extends TaskEvent{
  final Task task;
  final String currentTaskId;
  const AddTask(this.task, this.currentTaskId);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent{
  final Task task;
  final String currentTaskId;
  const UpdateTask(this.task, this.currentTaskId);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent{
  final String taskID;
  final String currentTaskId;
  const DeleteTask(this.taskID, this.currentTaskId);

  @override
  List<Object> get props => [taskID];
}

class UpdateTaskOrder extends TaskEvent {
  final List<Task> tasks;
  final String currentTaskId;
  const UpdateTaskOrder (this.tasks, this.currentTaskId);
}

class SetCurrentTask extends TaskEvent {
  final String taskId;
  const SetCurrentTask(this.taskId);
}


