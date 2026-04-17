import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moody_tasks/config/route_generator.dart';
import 'package:moody_tasks/config/injection.dart';
import 'features/tasks/bloc/task_bloc.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:task_repository/domain/abstract_repos/task_repository_abstract.dart';
import 'themes/default_theme.dart';
import 'utils/config_controller.dart';

/// The main view of the application, setting up MaterialApp and providing necessary blocs.
/// It reads the color scheme from ConfigController, and initializes the TaskBloc with a LocalTaskRepository.
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final configController = getIt<ConfigController>();
      
    return AnimatedBuilder(
      animation: configController,
      builder: (context, _) {

      return BlocProvider(
          create: (context) => TaskBloc ( repository: getIt<TaskRepository>() )..add(LoadTasks()),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Moody Tasks',
            theme: ThemeData( colorScheme: lightScheme, useMaterial3: true),
            darkTheme: ThemeData(colorScheme: darkScheme, useMaterial3: true),
            themeMode: configController.config.theme == null ||
                        configController.config.theme!.contains('Light')
                        ? ThemeMode.light
                        : ThemeMode.dark,
      
            home: MainLayout(),
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      }

    );    
  }

}
