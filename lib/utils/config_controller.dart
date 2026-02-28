
import 'package:config_repository/domain/entities/config.dart';
import 'package:config_repository/domain/repositories/config_repository_abstract.dart';
import 'package:flutter/material.dart';

class ConfigController extends ChangeNotifier {
  final ConfigRepository _repo;
  Config _config = Config();

  ConfigController(this._repo);

  Config get config => _config;

  Future<void> load() async {
    try{
    _config = await _repo.loadAllAppConfigs();
    notifyListeners();
    }catch(e){ print('ConfigController: error loading configurations: $e'); }
  }

  Future<void> update({
    String? userName,
    String? selectedMood,
    double? weeklyHoursGoal,
    DateTime? timeSinceLastMoodSelection,
    bool? isMoodScreenFirstUse,
    bool? isTaskListScreenFirstUse,
    bool? isPomodoroScreenFirstUse,
  }) async {
    final newConfig = _config.copyWith(
      userName: userName,
      selectedMood: selectedMood,
      weeklyHoursGoal: weeklyHoursGoal,
      timeSinceLastMoodSelection: timeSinceLastMoodSelection,
      isMoodScreenFirstUse: isMoodScreenFirstUse,
      isTaskListScreenFirstUse: isTaskListScreenFirstUse,
      isPomodoroScreenFirstUse: isPomodoroScreenFirstUse,
    );

    await _repo.saveAllAppConfigs(newConfig);
    _config = newConfig;
    notifyListeners();

  }
}
