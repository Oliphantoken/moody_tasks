import 'dart:convert';
import 'package:pomodoro_repository/domain/repositories/pomodoro_repository_abstract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalPomodoroRepository implements PomodoroRepository {
  static const String _countKey = 'pomodoroCounts';
  static const String _currentPomodoroIDKey = 'currentKey';

  @override
  Future<Map<String, int>> loadAllPomodoroCounts({SharedPreferences? prefs}) async {
    try{
    prefs ??= await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_countKey) ?? '{}';

    //Must be 'dynamic' instead of 'int' value
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    //Cast value to int here
    return decoded.map((key, value) => MapEntry(key, value as int),);
    }catch(e) {
      print('Error loading Pomodoro counts: $e');
      return <String, int>{}; 
    }
  }

  @override
  Future<int> getPomodoroCount(String taskId) async {
    final pomodoros = await loadAllPomodoroCounts();
    return pomodoros[taskId]?.toInt() ?? 0;
  }

  @override
  Future<void> saveAllPomodoroCounts(Map<String, int> map) async {
    final prefs = await SharedPreferences.getInstance();
    final pomodoros = await loadAllPomodoroCounts(prefs: prefs);
    try{
    // Merge existing with new values (new map overrides old)
    pomodoros.addAll(map);


    await prefs.setString(_countKey, jsonEncode(pomodoros));
    }catch(e){
      print("Error saving all pomodoro counts: $e");
    }
  }

  @override
  Future<void> savePomodoroCount(String taskId, int count) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pomodoros = await loadAllPomodoroCounts(prefs: prefs);
      pomodoros[taskId] = count;
      await prefs.setString(_countKey, jsonEncode(pomodoros));
    } catch (e) {
      print("Error saving a pomodoro count: $e");
    }
  }

  ///Delete a task's completed pomodoro count from DB
  @override
  Future<int?> deletePomodoroCount(String taskId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pomodoros = await loadAllPomodoroCounts(prefs: prefs);
      final ret = pomodoros.remove(taskId);
      print('REPO delete return: $ret');
      await prefs.setString(_countKey, jsonEncode(pomodoros));
      return ret;
    } catch (e) {
      print("Error deleting a pomodoro count: $e"); 
      return -1;   
    }
  }


  @override
  Future<String> getCurrentPomodoroID() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentPomodoroIDKey) ?? '';
    } catch (e) { print("Error getting the current pomodoro ID: $e"); return ''; }
  }

  @override
  Future<void> setCurrentPomodoroID(String taskID) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_currentPomodoroIDKey, taskID);
    } catch (e) { print("Error setting the current pomodoro ID: $e"); }
  }

  @override
  Future<bool> savePomodoroState(Map<String, int> map, String currentTaskID) async {
    try{
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_countKey, jsonEncode(map));
      prefs.setString(_currentPomodoroIDKey, currentTaskID);
    return true;
    }catch(e){
      print('Error saving pomodoro state: $e');
      return false;
    }
  }

  @override
  Future<Map<String, int>?> loadPomodoroState() async{
    try {
      final prefs = await SharedPreferences.getInstance();
      String currentTask = prefs.getString(_currentPomodoroIDKey) ?? '';
      final pomodoros = await loadAllPomodoroCounts(prefs: prefs);
      final state = <String, int>{currentTask: 0};
      state.addAll(pomodoros);
      return state;

    } catch (e) { print('Error loading pomodoro state: $e'); return null; }
  }

}
