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
            colorScheme: activeScheme()
          ),

          home: MainLayout(),
          onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );    
    
  }

  ColorScheme activeScheme(){
    var time = TimeOfDay.now();
    if(time.isAfter(TimeOfDay(hour: 7 , minute: 00))
    && time.isBefore(TimeOfDay(hour: 18, minute: 00)) ){
      return ColorScheme.light(
            //   surface: Colors.grey.shade100,
            //   onSurface: Colors.black,
            //   primary: Color.fromARGB(255, 69, 145, 134),
            //   secondary: Color.fromARGB(255, 233, 208, 187),
            //   tertiary: Color(0xFFADDBC7),
            //   shadow:  Colors.grey.shade300,
            //   outline: Color(0xFFAFA085),//Colors.grey.shade400,
            );
    }else {
      return ColorScheme.dark();
    }
  }

}
