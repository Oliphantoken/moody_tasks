import 'dart:convert';
import 'package:config_repository/data/models/config_model.dart';
import 'package:config_repository/domain/config_repositories_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

 class LocalConfigRepository implements ConfigRepository {
   static const String _key = 'appConfig';

   @override
  Future<Config> loadAllAppConfigs({SharedPreferences? prefs}) async {
    try{
    prefs ??= await SharedPreferences.getInstance();
    prefs.remove('pomodoroCounts');

    final jsonString = prefs.getString(_key);

    if(jsonString == null || jsonString.isEmpty){
      return Config();
    }

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;

    Config config = ConfigModel.fromMap(decoded).toEntity();
     
    return config;

    }catch(e) {
      print('Error loading configurations: $e');
      return Config(); 
    }
  }

  @override
  Future<void> saveAllAppConfigs(Config newConfig) async {
    final prefs = await SharedPreferences.getInstance();
    //final configs = await loadAllAppConfigs(prefs: prefs);
    try{
      final model = ConfigModel.fromEntity(newConfig).toMap();
      await prefs.setString(_key, jsonEncode(model));
    }catch(e){
      print("Error saving all pomodoro counts: $e");
    }
  }
}
