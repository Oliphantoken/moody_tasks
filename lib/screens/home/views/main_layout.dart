//Flutter imports
import 'dart:math';
import 'package:config_repository/domain/entities/config.dart';
import 'package:flutter/material.dart';
import 'package:moody_tasks/config/injection.dart';
import 'package:moody_tasks/features/pomodoro/views/pomodoro_screen.dart';
//Screen imports
import 'package:moody_tasks/features/tasks/views/task_list_screen.dart';
import 'package:moody_tasks/features/moods/views/mood_screen.dart';
import 'package:moody_tasks/utils/config_controller.dart';
import 'package:pomodoro_repository/domain/repositories/pomodoro_repository_abstract.dart';

enum SCREENS{
  home,
  taskList,
  pomodoro,
  taskCreation,
  mood
}

/// The main layout template.
/// It uses a StatefulWidget to manage the current screen index and rebuilds the UI accordingly.
/// It also integrates a Floating Action Button for adding new tasks.
class MainLayout extends StatefulWidget {
  static String? currentTask = "";
  static Config? configs;

  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int screenIndex = SCREENS.home.index;

   @override
  void initState() {
    super.initState();
    getIt<ConfigController>().load();
    _loadCurrentTaskId();
  }
  
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: [
          //Instead of a switch statement, will go through incrementally
          MoodScreen(),
          TaskListScreen(),
          PomodoroScreen(),
        ][screenIndex],

        //Bottom Nav Bar
        bottomNavigationBar: _drawBottomNavigationBar(context),

        //Bottom Add button
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat,
        floatingActionButton: _drawFloatingActionButton(context),
      );
    }

  ///Bottom Navigation Bar
  ClipRRect _drawBottomNavigationBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),

      child: BottomNavigationBar(
        //Screen buttons
        onTap: (value) {
          setState(() {
            screenIndex = value;
          });
        },

        currentIndex: screenIndex,
        backgroundColor: Colors.white,
        elevation: 3,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          //Home button
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          //Task List
          BottomNavigationBarItem(
            icon: Icon(Icons.task_rounded),
            label: 'Tasks',
          ),

          //Pomodoro
          BottomNavigationBarItem(
            icon: Icon(Icons.punch_clock_rounded),
            label: 'Pomodoro',
          ),
        ],
      ),
    );
  }

  ///Floating Action Button
  Container _drawFloatingActionButton(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: 50,
      height: 50,

      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/newTask');
          if(result == 'goToTasks'){
            setState(() {
              screenIndex = SCREENS.taskList.index;
            });
          }
        },

        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.amber,
                Colors.yellow,
                Colors.amber,
                // Theme.of(context).colorScheme.tertiary,
                // Theme.of(context).colorScheme.secondary,
                // Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(Icons.add, color: Colors.black87,),
        ),
      ),
    );
  }

  void changeScreen(int index) {
    setState(() {
      screenIndex = index;
    });
  }

  Future<void> _loadCurrentTaskId() async {
    try {
      MainLayout.currentTask = await getIt<PomodoroRepository>().getCurrentPomodoroID();
    } catch (e) { print('MainLayout: Problem loading current task into MainLayout: $e'); }
    
  }

  Future<void> changeCurrentTask(String taskID) async {
     try {
      await getIt<PomodoroRepository>().setCurrentPomodoroID(taskID);
      MainLayout.currentTask = taskID;
    } catch (e) { print('MainLayout: Problem setting current task into MainLayout: $e'); }
  }

  void moodTimer(){
    
  }
  

  
}


