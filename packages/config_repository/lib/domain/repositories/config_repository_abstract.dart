import 'package:config_repository/domain/config_repositories_export.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ConfigRepository{
    Future<Config> loadAllAppConfigs({SharedPreferences? prefs});
    Future<void> saveAllAppConfigs(Config configs);
}