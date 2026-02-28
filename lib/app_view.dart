import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moody_tasks/config/route_generator.dart';
import 'package:moody_tasks/config/injection.dart';
import 'features/tasks/bloc/task_bloc.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:task_repository/domain/abstract_repos/task_repository_abstract.dart';

/// The main view of the application, setting up MaterialApp and providing necessary blocs.
/// It uses a light color scheme and initializes the TaskBloc with a LocalTaskRepository.
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
        create: (context) => TaskBloc ( repository: getIt<TaskRepository>() )..add(LoadTasks()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Moody Tasks',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              surface: Colors.grey.shade100,
              onSurface: Colors.black,
              primary: Color(0xFF00B2E7),
              secondary: Color(0xFFE064F7),
              tertiary: Color(0xFFFF8D6C),
              outline: Colors.grey.shade400,
            ),
          ),

          home: MainLayout(),
          onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );    
    
  }

}
