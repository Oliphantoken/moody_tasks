
class PomodoroCount{
  final String taskId;
  final int count;

  const PomodoroCount({required this.taskId,required this.count});

  PomodoroCount copyWith({String? taskId, int? count}){
    return PomodoroCount(
      taskId: taskId ?? this.taskId,
      count: count ?? this.count
    );
  }

}