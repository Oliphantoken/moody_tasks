class Config {
  String? userName;
  String? selectedMood;
  double? weeklyHoursGoal;
  String? theme;
  DateTime? timeSinceLastMoodSelection;
  bool? isMoodScreenFirstUse;
  bool? isTaskListScreenFirstUse;
  bool? isPomodoroScreenFirstUse;
  //Theme? theme

  Config({
    this.userName,
    this.selectedMood,
    this.weeklyHoursGoal,
    this.theme,
    this.timeSinceLastMoodSelection,
    this.isMoodScreenFirstUse, 
    this.isTaskListScreenFirstUse,
    this.isPomodoroScreenFirstUse,
  });

  Config copyWith({DateTime? timeSinceLastMoodSelection, String? userName, String? selectedMood, double? weeklyHoursGoal,
  String? theme, bool? isMoodScreenFirstUse, bool? isTaskListScreenFirstUse, bool? isPomodoroScreenFirstUse,}){
    return Config(
      userName: userName ?? this.userName,
      selectedMood: selectedMood ?? this.selectedMood,
      weeklyHoursGoal: weeklyHoursGoal ?? this.weeklyHoursGoal,
      theme: theme ?? this.theme,
      timeSinceLastMoodSelection: timeSinceLastMoodSelection ?? this.timeSinceLastMoodSelection,
      isMoodScreenFirstUse: isMoodScreenFirstUse ?? this.isMoodScreenFirstUse,
      isPomodoroScreenFirstUse: isPomodoroScreenFirstUse ?? this.isPomodoroScreenFirstUse,
      isTaskListScreenFirstUse: isTaskListScreenFirstUse ?? this.isTaskListScreenFirstUse,
    );
  }

}