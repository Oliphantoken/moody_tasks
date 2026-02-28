
import 'package:shared_preferences/shared_preferences.dart';

abstract class PomodoroRepository {
  Future<Map<String, int>> loadAllPomodoroCounts({SharedPreferences? prefs});
  Future<int> getPomodoroCount(String taskId);
  Future<void> savePomodoroCount(String taskId, int count);
  Future<void> saveAllPomodoroCounts(Map<String, int> map);
  Future<int?> deletePomodoroCount(String taskID);
  Future<String> getCurrentPomodoroID();
  Future<void> setCurrentPomodoroID(String taskID);
  Future<bool> savePomodoroState(Map<String, int> map, String currentTaskID);
  Future<Map<String, int>?> loadPomodoroState();
}