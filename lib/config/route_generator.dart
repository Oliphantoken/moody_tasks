import 'package:flutter/material.dart';
import 'package:moody_tasks/features/pomodoro/views/pomodoro_screen.dart';
import 'package:moody_tasks/features/tasks/views/task_creation.dart';
import 'package:moody_tasks/features/tasks/views/task_details.dart';
import 'package:moody_tasks/features/tasks/views/task_list_screen.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:moody_tasks/screens/home/views/settings_screen.dart';
import 'package:task_repository/domain/entities/task.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch(settings.name){
      case '/': return MaterialPageRoute(builder: (_) => MainLayout());
      case '/taskList': return MaterialPageRoute(builder: (_) => TaskListScreen());
      case '/newTask': return MaterialPageRoute(builder: (_) => TaskCreation());
      case '/editTask':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (_) => TaskDetails(selectedTask: args['task'] as Task, currTaskId: args['currentTaskId'] as String));
      case '/pomodoro': return MaterialPageRoute(builder: (_) => PomodoroScreen());
      case '/appsettings': return MaterialPageRoute(builder: (_) => SettingsScreen());
      default: return _errorRoute();
    }
  }
  
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('404')
          ),
          body: Center(
            child: Text('Oh, something went wrong!')
          )
        );

      }
    ); 
  }

}