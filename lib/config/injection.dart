// Dependency Injection Container setup file using GetIt

import 'package:config_repository/data/repositories/local_config_repository.dart';
import 'package:config_repository/domain/repositories/config_repository_abstract.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:moody_tasks/utils/config_controller.dart';
import 'package:pomodoro_repository/data/repositories/local_pomodoro_repository.dart';
import 'package:pomodoro_repository/domain/repositories/pomodoro_repository_abstract.dart';
import 'package:task_repository/data/repositories/sqflite_task_repository.dart';
import 'package:task_repository/domain/abstract_repos/task_repository_abstract.dart';
import 'package:task_repository/data/repositories/local_task_repository.dart';
import 'package:task_repository/data/repositories/mock_task_repository.dart';
import 'package:moody_tasks/data/mock/data.dart';

enum REPOS{
  mocks,
  local,
  sqfl,
}
final getIt = GetIt.instance;

void setupInjection(REPOS repo) {

  // Register your dependencies here
  //Use Mock data for web as it doesn't support SQFLite
  if(kIsWeb){
    repo = REPOS.mocks;
  }

  //Task repo
  switch(repo){
    case REPOS.mocks: // Register mock implementations for testing
      getIt.registerLazySingleton<TaskRepository>(() => MockTaskRepository()..addTasksFromMockData(tasklistData));
      break;
    case REPOS.local: // Register real implementations for production
      getIt.registerLazySingleton<TaskRepository>( () => LocalTaskRepository());
      break;
    case REPOS.sqfl: // Register SQFLite database implementation
      getIt.registerLazySingleton<TaskRepository>(() => SqfliteTaskRepository());
      break;
  }

  //Pomodoro repo
  getIt.registerLazySingleton<PomodoroRepository>( () => LocalPomodoroRepository());

  //Configs repo: register the config controller based on the config repo
  getIt.registerLazySingleton<ConfigRepository>(() => LocalConfigRepository());
  getIt.registerLazySingleton<ConfigController>(
    () => ConfigController(getIt<ConfigRepository>())
  );
  
  // Add more registrations as you build features, e.g. for authentication, you might have:
  // getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
}