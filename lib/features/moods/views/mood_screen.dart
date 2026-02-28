import 'dart:math';
import 'package:config_repository/domain/entities/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moody_tasks/config/injection.dart';
import 'package:moody_tasks/features/moods/mood_presets.dart';
import 'package:moody_tasks/features/tasks/bloc/task_bloc.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:moody_tasks/utils/animated_progress_circle.dart';
import 'package:moody_tasks/utils/config_controller.dart';
import 'package:moody_tasks/utils/helper_functions.dart';
import 'package:moody_tasks/utils/mood_responses.dart';
import 'package:task_repository/domain/entities/task.dart';
import 'package:task_repository/domain/value_types.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  bool _hasLoadedFromConfig = false;

  bool _isMoodSelected = false;
  Mood? _selectedMood;
  double weeklyHoursGoal = 10.0;
  Task? currentTask;
  late final ConfigController _configController;


  @override
  void initState(){
    super.initState();
    _configController = getIt<ConfigController>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
   Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _configController,
      builder: (context, _){
        final configs = _configController.config;
        weeklyHoursGoal = configs.weeklyHoursGoal ?? 10;
        print("_isMoodSelected: $_isMoodSelected");
        print("_selectedMood before: $_selectedMood");
        print("configs.selectedMood: ${configs.selectedMood}");
        
        _checkMoodExpiry(configs);
        
        print("_isMoodSelected after being set: $_isMoodSelected");
        print("_selectedMood after: $_selectedMood");

        return BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          print(
            "MoodScreen rebuild - tasks: ${(state is TaskSuccess) ? state.tasks.length : 'none'}",
          );
          List<Task> tasks = [];
          if (state is TaskSuccess) tasks = state.tasks;
      
          if(tasks.isEmpty){
            return SafeArea(
            child: Center( child: Text('Welcome'))
            );
          }
      
          //Set currentTask
          currentTask = tasks.firstWhere((t) => t.id == MainLayout.currentTask, orElse: () => Task.empty);
      
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
          
              //Vertically list of things
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _showAppBar(context, configs), //"App Bar" part

                    const SizedBox(height: 20),
                    
                    _showProgressbox(context, tasks),
      
                    const SizedBox(height: 20),
      
                    _showCurrentTaskbox(context, currentTask),
      
                    const SizedBox(height: 20),
      
                    _showMoodbox(context), //Mood Box
                        
                    const SizedBox(height: 5),
                    
                    if(_isMoodSelected)
                      _showResponseBubbles(context, tasks, _selectedMood)
                  ],
                ),
              ),
            ),
          );
        },
      );
      }
    );
  }

///App bar area
  Padding _showAppBar(BuildContext context, Config c) {
    Color? iconColor = Colors.grey;
    if(_isMoodSelected){
      iconColor = MoodPresets.getMoodColor[_selectedMood];
    }
    
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Left side: Profile row
          Row(
            children: [
              //Profile Icon
              Stack(
                alignment: Alignment.center,
                children: _isMoodSelected ? [
                  //Bg circle
                  Container( width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor?.withValues(red: iconColor.r-0.5, green: iconColor.g-0.5, blue: iconColor.b-0.5))),
                  //Profile icon
                  Icon(MoodPresets.getMoodIcon[_selectedMood], color: iconColor),
                ] : [
                  Container( width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: iconColor)),
                  Icon(Icons.person, color: Colors.grey[900]),
                ],
              ),
              SizedBox(width: 10),
              //Column for vertical text order
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Greeting
                  Text("Welcome!", style: TextStyle( fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.outline)),
                  Text(c.userName ?? "Moody Tasker!", style: TextStyle( fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface)),
                ]
              ),
            ],
          ),

          //Right side: action buttons
          IconButton(icon: Icon(Icons.settings), onPressed: () {
            Navigator.pushNamed(context, '/appsettings');
          }),
        ],
      ),
    );

  }

  Column _buildMoodIcon(Mood mood, IconData iconData, Color iconColor, double iconSize, Color fontColor, double fontSize){
    Color darkColor = iconColor;
    if(_isMoodSelected){
      darkColor = iconColor.withValues(red: iconColor.r-0.5, green: iconColor.g-0.5, blue: iconColor.b-0.5);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: _isMoodSelected ? BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: darkColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 5),
              ),
            ] 
          ) : null,
          child: IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(12),   // Internal padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: Icon(iconData, color: iconColor, size: iconSize), 
            onPressed: (){
              //Deselect mood is time based now
              //Select mood
              if(!_isMoodSelected){
                setState(() {
                  _selectedMood = mood;
                  _isMoodSelected = true;
                });
                _configController.update(
                  selectedMood: mood.displayName,
                  timeSinceLastMoodSelection: DateTime.now()
                );
              }
            },
          ),
        ),
        
        Text( 
          mood.displayName,
          style: TextStyle(
            fontSize: fontSize,
            color: _isMoodSelected ? darkColor : fontColor, 
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Container _showProgressbox(BuildContext context, List<Task> tasks){
    final completedTasks = tasks.where((task)=> task.isDone);
    double totalDuration = 0.0;
    for(Task t in completedTasks){
      totalDuration += t.duration;
    }

    final progress = ((totalDuration/60.0)/weeklyHoursGoal);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width/3,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),

      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("You've done ${(totalDuration/60.0).toStringAsPrecision(2)} hours of tasks this week!",
            style: TextStyle(fontWeight: FontWeight.bold),),

          SizedBox(height: 5),

          Text("${(progress*100).ceil()}% of your weekly goal is completed",
            style: TextStyle(fontSize: 12, color: Colors.black87)),

          SizedBox(height: 20),

          Stack(
            children:[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(25)
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width * progress,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                )
              ),
            ]
          ),

        ],
      ),
    );
  }

  Widget _showCurrentTaskbox(BuildContext context, Task? currenttask){
    if(currenttask == null || currenttask == Task.empty){
      return Container();
    }

    return TextButton(
      onPressed: () async {
        final state = context.findAncestorStateOfType<MainLayoutState>();
        state?.changeScreen(SCREENS.pomodoro.index);  // safe call
      },
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: Colors.black),
        foregroundColor: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your current task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
    
          SizedBox(height: 10),
    
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],                  
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Left: Item icon and name
                  Row(
                    children: [
                      Icon(Helper.getCategoryNameToIconData[currenttask.category.name] ?? Icons.category, size: 20, color: Color(currenttask.category.color)),  

                      // //---------------------------
                      // //Progress Icon
                      // //---------------------------
                      // Stack(
                      //   alignment: Alignment.center,
                      //   children: [
                      //     SizedBox(
                      //       width: 35,
                      //       height: 35,
                      //       child: AnimatedProgressCircle(
                      //         percentage:
                      //             currenttask.completionRate * 100,
                      //         colour: Helper.getColorBasedOnTaskStatus(
                      //           currenttask.status,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(width: 12),
                      //---------------------------
                      //Item title and stats
                      //---------------------------
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currenttask.title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
        
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor:
                                    currenttask.status == TaskStatus.completed
                                    ? Colors.green
                                    : Helper.getColorBasedOnDueDate(
                                        currenttask.dueDate,
                                      ),
                              ),
                              SizedBox(width: 3),
                              Text(
                                "Due ${DateFormat('dd.MM.yy').format(currenttask.dueDate)}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  //---------------------------
                  //Right: item duration and category
                  //---------------------------
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currenttask.duration.toStringAsFixed(0),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
        
                          Text(
                            "mins",
                            style: TextStyle(
                              fontSize: 10,
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
        
                      SizedBox(width: 18),
        
                      //Category
                      //Icon(Helper.getCategoryNameToIconData[currenttask.category.name] ?? Icons.category, size: 20, color: Color(currenttask.category.color)),  
                    //---------------------------
                      //Progress Icon
                      //---------------------------
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: AnimatedProgressCircle(
                              percentage:
                                  currenttask.completionRate * 100,
                              colour: Helper.getColorBasedOnTaskStatus(
                                currenttask.status,
                              ),
                            ),
                          ),
                        ],
                      ),
                    
                    
                    ],
                  ),
                ], //Big row
              ),
            ),
          ),      
        ],
      )
    );
  }

  Widget _showMoodbox(BuildContext context) {
    //Selected mood
    if(_isMoodSelected){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMoodIcon(_selectedMood!, MoodPresets.getMoodIcon[_selectedMood]! , MoodPresets.getMoodColor[_selectedMood]!, 60, MoodPresets.getMoodColor[_selectedMood]!, 16),
        ]
      );
    
    //Not selected mood yet
    }else {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 1.6,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //Background
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 4,
            color: Colors.grey.shade300,
            offset: Offset(5, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi / 4),
        ),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          const Text(
            "How are you feeling today?",
            style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodIcon(Mood.content, MoodPresets.getMoodIcon[Mood.content]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.excited, MoodPresets.getMoodIcon[Mood.excited]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.sad, MoodPresets.getMoodIcon[Mood.sad]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.upset, MoodPresets.getMoodIcon[Mood.upset]!, Colors.white, 40, Colors.white, 14),
            ],
          ),          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMoodIcon(Mood.determined, MoodPresets.getMoodIcon[Mood.determined]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.panicking, MoodPresets.getMoodIcon[Mood.panicking]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.restless, MoodPresets.getMoodIcon[Mood.restless]!, Colors.white, 40, Colors.white, 14),
              _buildMoodIcon(Mood.drained, MoodPresets.getMoodIcon[Mood.drained]!, Colors.white, 40, Colors.white, 14),
            ],
          ),
        ],
      ),
    );
    }
  }

  Container _showResponseBubbles(BuildContext context, List<Task> tasks, Mood? moodType){
    List<Task> filteredTasks = List.empty();
    String response = "";
    final randomise = Random();

    if(tasks.isEmpty) {
        response = "${MoodResponses.noTasksResponses[randomise.nextInt(MoodResponses.noTasksResponses.length)]}";
    } else {
      //Tasks that are not completed, not current task, and are for the next 7 days
      final duelist = tasks.where((task){
        return !task.isDone &&
        task.id != currentTask?.id &&
        task.dueDate.isBefore(DateTime.now().add(const Duration(days: 7)));
      }).toList();

      if(duelist.isEmpty){
        response = "${MoodResponses.noTasksResponses[randomise.nextInt(MoodResponses.noTasksResponses.length)]}";
      }
      //If there are only 2 or less in the list, just return it
      else if(duelist.length < 3){
        filteredTasks = duelist;
      }
      //There are more than 2 tasks in the duelist, let's sort them according to priority + mood criteria
      else { 
        switch(moodType){
          //Positive Strong emotions
          case Mood.excited:
          case Mood.determined: {
        
           //2 tasks with high ->medium ->low priority
            final priolist = duelist.where((task) => task.priority == Priority.high).toList();
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.medium));
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.low)); 
            
            //2 prioritised tasks that are complex ->moderate ->easy 
            filteredTasks = priolist.where((task) => task.complexity == Complexity.complex).toList();
            if(filteredTasks.length < 2) filteredTasks.addAll(priolist.where((task) => task.complexity == Complexity.moderate));
            if(filteredTasks.length < 2) filteredTasks.addAll(priolist.where((task) => task.complexity == Complexity.easy));
            
            //The response
            response = "${MoodResponses.posStrongStarter[randomise.nextInt(MoodResponses.posStrongStarter.length)]}\n${MoodResponses.posStrongResponses[randomise.nextInt(MoodResponses.posStrongResponses.length)]}";
            break;
          }

          //Positive Weak emotions
          case Mood.content: {
            //2 tasks with high ->medium ->low priority
            final priolist = duelist.where((task) => task.priority == Priority.high).toList();
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.medium));
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.low)); 
            
            //2 prioritised tasks that are complex ->moderate ->easy 
            filteredTasks = priolist.where((task) => task.complexity == Complexity.complex).toList();
            if(filteredTasks.length < 2) filteredTasks.addAll(priolist.where((task) => task.complexity == Complexity.moderate));
            if(filteredTasks.length < 2) filteredTasks.addAll(priolist.where((task) => task.complexity == Complexity.easy));
            
            response = "${MoodResponses.posWeakStarter[randomise.nextInt(MoodResponses.posWeakStarter.length)]}\n${MoodResponses.posStrongResponses[randomise.nextInt(MoodResponses.posStrongResponses.length)]}";
            break;
          }

          //Negative Strong emotions
          case Mood.angry:
          case Mood.upset: {
            //2 prioritised tasks that are moderate ->easy 
            filteredTasks = duelist.where((task) => task.complexity == Complexity.moderate).toList();
            if(filteredTasks.length < 2) filteredTasks.addAll(duelist.where((task) => task.category.categoryType == CategoryType.environment)); 
            if(filteredTasks.length < 2) filteredTasks.addAll(duelist.where((task) => task.complexity == Complexity.moderate));
            
            //The response
            response = "${MoodResponses.negStarter[randomise.nextInt(MoodResponses.negStarter.length)]}\n${MoodResponses.negStrongResponses[randomise.nextInt(MoodResponses.negStrongResponses.length)]}";
            break;
          }

          //Negative Strong emotions
          case Mood.stressed:
          case Mood.panicking: {
            //2 tasks with high ->medium ->low priority
            final priolist = duelist.where((task) => task.priority == Priority.medium).toList();
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.high));
            if(priolist.length < 2) priolist.addAll(duelist.where((task) => task.priority == Priority.low)); 

            //2 prioritised tasks that are moderate ->easy 
            filteredTasks = priolist.where((task) => task.complexity == Complexity.easy).toList();
            if(filteredTasks.length < 2) filteredTasks.addAll(priolist.where((task) => task.category.categoryType ==  CategoryType.body || task.category.categoryType == CategoryType.mindAndSpirit)); 
            
            //The response
            response = "${MoodResponses.negStarter[randomise.nextInt(MoodResponses.negStarter.length)]}\n${MoodResponses.negStrongResponses[randomise.nextInt(MoodResponses.negStrongResponses.length)]}";
            
          }

          //Negative Weak emotions
          case Mood.sad:
          case Mood.drained:
          case Mood.restless:
          case Mood.aimless: {
            //2 prioritised tasks that are moderate ->easy 
            filteredTasks = duelist.where((task) => task.complexity == Complexity.easy).toList();
            if(filteredTasks.length < 2) filteredTasks.addAll(duelist.where((task) => task.category.categoryType ==  CategoryType.body || task.category.categoryType == CategoryType.mindAndSpirit || task.category.categoryType == CategoryType.fun)); 
            
            //The response
            response = "${MoodResponses.negStarter[randomise.nextInt(MoodResponses.negStarter.length)]}\n${MoodResponses.negWeakResponses[randomise.nextInt(MoodResponses.negWeakResponses.length)]}";
            
          }

          default: {
            response = "${MoodResponses.noTasksResponses[randomise.nextInt(MoodResponses.noTasksResponses.length)]}";
          }
        }
      }
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/2,
      padding: EdgeInsets.symmetric(vertical: 20),
    
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: (filteredTasks.length > 1)? [
            _buildBubble(response, null, 230, 200, MainAxisAlignment.start),
            _buildBubble(null, filteredTasks[0], 150, 100, MainAxisAlignment.end),
            SizedBox(height: 30),
            _buildBubble(null, filteredTasks[1], 200, 70, MainAxisAlignment.center),
        ] : filteredTasks.isNotEmpty? [
            _buildBubble(response, null, 230, 200, MainAxisAlignment.start),
            _buildBubble(null, filteredTasks[0], 150, 100, MainAxisAlignment.end),
        ] : [ _buildBubble(response, null, 230, 200, MainAxisAlignment.start) ]

      )
    );
  }

  Row _buildBubble(String? label, Task? task, double width, double height, MainAxisAlignment alignment){
    
    return Row(
      
      mainAxisAlignment: alignment,
      
      children: (task == null)? [
        Image.asset('assets/icons/healthcare.png', scale: 0.6, color: Colors.pink[100],),
        SizedBox(width:width, child: Text(label??"", maxLines: 5, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.normal),))    
      ] : [
        Container(
          width: width,
          height: height,
       
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child:
            TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[300],
                elevation: 2,
                shadowColor: Colors.grey,
              ),
              icon: Icon(Helper.getCategoryNameToIconData[task.category.name], color: Color(task.category.color),size: 30),
              onPressed: () async {
                final state = context.findAncestorStateOfType<MainLayoutState>();
                await state?.changeCurrentTask(task.id);
                state?.changeScreen(SCREENS.pomodoro.index);  // safe call
              },
              label: Text(task.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal),),
            ) 
        )
      ],
    );
  }

  void _checkMoodExpiry(Config c) {

    if(c.timeSinceLastMoodSelection != null){
      final hoursPassed = DateTime.now()
      .difference(c.timeSinceLastMoodSelection!).inHours;
      if(hoursPassed >= 12){
        c.selectedMood = '';
        c.timeSinceLastMoodSelection = null;
      }
    }
  
    try{
      _selectedMood = Mood.values.firstWhere((m)=> m.displayName == c.selectedMood);
    }catch(e){ _selectedMood = null; }
    
    _isMoodSelected = (c.selectedMood != null && c.selectedMood != "");

  }

}