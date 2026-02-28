import '../../domain/pomodoro_repository_export.dart';

class PomodoroCountModel {
  final String taskId;
  final int count;

  PomodoroCountModel({required this.taskId, required this.count});

  factory PomodoroCountModel.fromMap(Map<String, dynamic> json){
    return PomodoroCountModel(
      taskId: json['taskId'] as String, 
      count: json['count'] as int
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'taskId':taskId,
      'count': count
    };
  }

  PomodoroCount toEntity(){
    return PomodoroCount(taskId: taskId, count: count);
  }

  factory PomodoroCountModel.fromEntity(PomodoroCount entity){
    return PomodoroCountModel(taskId: entity.taskId, count: entity.count);
  }

}