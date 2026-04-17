import 'package:config_repository/domain/entities/config.dart';

class ConfigModel {
  String? userName;
  String? selectedMood;
  double? weeklyHoursGoal;
  String? theme;
  int? timeSinceLastMoodSelectionInt;
  bool? isMoodScreenFirstUse;
  bool? isTaskListScreenFirstUse;
  bool? isPomodoroScreenFirstUse;
  //Theme? theme

  ConfigModel({
    this.userName,
    this.selectedMood,
    this.weeklyHoursGoal,
    this.theme,
    this.timeSinceLastMoodSelectionInt,
    this.isMoodScreenFirstUse,
    this.isTaskListScreenFirstUse,
    this.isPomodoroScreenFirstUse,
  });

  factory ConfigModel.fromMap(Map<String, dynamic> json){
    return ConfigModel(
      userName: json['userName'] as String?,
      selectedMood: json['selectedMood'] as String?,
      weeklyHoursGoal: (json['weeklyHoursGoal'] as num?)?.toDouble(),
      theme: json['theme'] as String?,
      timeSinceLastMoodSelectionInt: json['timeSinceLastMoodSelectionInt'] as int?,
      isMoodScreenFirstUse: json['isMoodScreenFirstUse'] as bool?,
      isPomodoroScreenFirstUse: json['isPomodoroScreenFirstUse'] as bool?,
      isTaskListScreenFirstUse: json['isTaskListScreenFirstUse'] as bool?,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'userName': userName,
      'selectedMood': selectedMood,
      'weeklyHoursGoal': weeklyHoursGoal,
      'theme': theme,
      'timeSinceLastMoodSelectionInt': timeSinceLastMoodSelectionInt,
      'isMoodScreenFirstUse': isMoodScreenFirstUse,
      'isPomodoroScreenFirstUse': isPomodoroScreenFirstUse,
      'isTaskListScreenFirstUse': isTaskListScreenFirstUse,
    };
  }

  Config toEntity(){
    return Config(
      userName: userName,
      selectedMood: selectedMood,
      weeklyHoursGoal: weeklyHoursGoal,
      theme: theme,
      timeSinceLastMoodSelection: timeSinceLastMoodSelectionInt != null
      ? DateTime.fromMillisecondsSinceEpoch(timeSinceLastMoodSelectionInt!)
      : null,
      isMoodScreenFirstUse: isMoodScreenFirstUse,
      isPomodoroScreenFirstUse: isPomodoroScreenFirstUse,
      isTaskListScreenFirstUse: isTaskListScreenFirstUse,
    
    );
  }

  factory ConfigModel.fromEntity(Config entity){
    return ConfigModel(
      userName: entity.userName,
      selectedMood: entity.selectedMood,
      weeklyHoursGoal: entity.weeklyHoursGoal,
      theme: entity.theme,
      timeSinceLastMoodSelectionInt: entity.timeSinceLastMoodSelection?.millisecondsSinceEpoch,
      isMoodScreenFirstUse: entity.isMoodScreenFirstUse,
      isPomodoroScreenFirstUse: entity.isPomodoroScreenFirstUse,
      isTaskListScreenFirstUse: entity.isTaskListScreenFirstUse,
    );
  }

}