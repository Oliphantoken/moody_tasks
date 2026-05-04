import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moody_tasks/data/icons.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:moody_tasks/utils/animated_progress_circle.dart';
import 'package:moody_tasks/utils/error_widget.dart';
import 'package:moody_tasks/utils/helper_functions.dart';
import 'package:task_repository/domain/Category_Presets.dart';
import 'package:task_repository/domain/entities/task.dart';
import 'package:task_repository/domain/value_types.dart';
import '../bloc/task_bloc.dart';

///Class to show the task list screen
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedView = 'All'; // Default selected filter
  final filteredTasks = [];
  String currentTask = ""; 
  var colorScheme; 

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    //BlocBuilder is our UI FSM
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        print("Task list rebuild - tasks: ${(state is TaskSuccess) ? state.tasks.length : 'none'}",);
        
        if (state is TaskLoading) {
          return showLoading();
        } else if (state is TaskSuccess) {
          if(state.currentTaskId != ""){
            currentTask = state.currentTaskId;
          }else if(MainLayout.currentTask != ""){
            print("CURRENT TASK: ${MainLayout.currentTask}");
            currentTask = MainLayout.currentTask!;
          }

          //If no tasks yet
          if(state.tasks.isEmpty){
            return _introMessage(context);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Task List',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            body: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 20,
                right: 20,
                bottom: 1,
              ),
              child: Column(
                children: [
                  //Filter buttons row
                  _showFilterButtons(context, state),

                  const SizedBox(height: 10),
                  //Tasks list view
                  _showTaskList(context, state.tasks, currentTask),
                ],
              ),
            ),
          );
        } else if (state is TaskFailure) {
          return showFailure(state);
        } else {
          return const SizedBox(child: Text("Task list: not ready yet"));
        }
      },
    );
  }

  ///If state is loading
  Widget showLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  ///If state is failure
  Widget showFailure(TaskFailure state) {
    //return Center(child: Text('Error: ${state.errorMessage}'));
    return AppErrorWidget(
      message: state.errorMessage,
      onRetry: () => context.read<TaskBloc>().add(LoadTasks()),
    );
  }

  ///Filter text button row
  Widget _showFilterButtons(BuildContext context, dynamic state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "View:",
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
            _filterButton("All"),
            _filterButton("Status"),
            _filterButton("Category"),            
            _filterButton("Complexity"),
          ],
        ),
         Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _filterButton("Priority"),
            _filterButton("Due Date"),
          ],
        ),
        //Divider
        Divider(height: 1, thickness: 1, color: Colors.black26),
        SizedBox(height: 5),
      ],
    );
  }

  ///Draw a filter button
  Widget _filterButton(String text) {
    return ChoiceChip(
      label: Text(text),
      labelStyle: TextStyle(fontSize: 14, color: Colors.grey, height: 1),
      padding: EdgeInsets.all(0),
      side: BorderSide.none,
      selectedColor: Colors.grey[300],
      selected: selectedView == text,
      showCheckmark: false,
      onSelected: (_) => setState(() => selectedView = text),
    );
  }


  ///1. Start here. There are a lot of repetitive code that was refactored into a few reusable methods.
  ///This method is called by the build method. It sorts the tasks depending on sorting criterium (selectedView)
  ///The returned "list of lists" (each enum type provides a list of enums, and each enum provides a list of tasks)
  ///is packed up by the spread operator into individual widgets
  Widget _showTaskList(BuildContext context, List<Task> tasks, String? currentTaskId) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(selectedView == 'All')
              _buildFilteredTaskList(context, tasks, currentTaskId)
            else if(selectedView == 'Status')
              ..._buildFilteredEnumItems(TaskStatus.values, (t)=>t.displayName, tasks, currentTaskId)
            else if(selectedView == 'Category')
              ..._buildFilteredEnumItems(CategoryType.values, (t)=>t.displayName, tasks, currentTaskId)
            else if(selectedView == 'Complexity')
              ..._buildFilteredEnumItems(Complexity.values, (t)=>t.displayName, tasks, currentTaskId)
            else if(selectedView == 'Priority')
              ..._buildFilteredEnumItems(Priority.values, (t)=>t.displayName, tasks, currentTaskId).reversed //taste
            else if(selectedView == 'Due Date')
              ..._buildFilteredEnumItems(DueBy.values, (t)=>t.displayName, tasks, currentTaskId)
            else _buildFilteredTaskList(context, tasks, currentTaskId)
          ]
        ),
      )
    );
  }

  ///2. Returns a list of filtered tasks (list of widgets) for each sorting value in a sorting method (enum value)
  List<Widget> _buildFilteredEnumItems<T extends Enum>(List<T> enumValues, String Function(T) displayName, List<Task> tasks, String? currentTaskId){
    IconData? icondata;
    Color? iconcolor;
    
    return enumValues
    .map((e) {
      final list = _getViewFilteredTasks(tasks, displayName(e));
      if(list.isEmpty){
        return SizedBox(height: 0);
      }
      
      else {
      // Set Icon and Color if possible
        if(enumValues.contains(TaskStatus.backlog)){ 
          iconcolor = Helper.getColorBasedOnTaskStatus(e as TaskStatus);
        }
        else if(enumValues.contains(CategoryType.body)) { 
          final cat = CategoryPresets.all.firstWhere((c) => c.categoryType == e, orElse: ()=>CategoryPresets.all.first);
          iconcolor = Color(cat.color);
          icondata = Helper.getCategoryNameToIconData[cat.name];
        }
        else if(enumValues.contains(Complexity.easy)) { 
          iconcolor = Helper.getColorBasedOnComplexity(e as Complexity);
        }
        else if(enumValues.contains(Priority.low)) { 
          iconcolor = Helper.getColorBasedOnPriority(e as Priority);
        }
        else if(enumValues.contains(DueBy.overdue)) { 
          iconcolor = Helper.getColorBasedOnDueBy(e as DueBy);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AbsorbPointer(
              child: Row(
                children: [
                  Icon(icondata ?? Icons.chat_bubble, size: 18, color: (iconcolor ?? Colors.black87)),
                  SizedBox(width: 5),
                  Text(displayName(e), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ]
              ),
            ),
            _buildFilteredTaskList(context, list, currentTaskId),
            AbsorbPointer(
              child: SizedBox(height: 32),
            ),
          ],
        );
      }
    })
    .where((w) => w != const SizedBox.shrink())
    .toList();
  }

  ///3. Returns a list of filtered tasks according to selectedFilter AND selectedView
  List<Task> _getViewFilteredTasks(List<Task> tasks, String selectedFilter){
    switch(selectedView){
      case 'All': return tasks;
      case 'Status': return tasks.where( (task) =>
              task.status.displayName == selectedFilter
              || selectedFilter == 'All',
            ).toList();  
      case 'Category': return tasks.where( (task) =>
              task.category.name == selectedFilter
              || selectedFilter == 'All',
            ).toList(); 
      case 'Complexity': return tasks.where( (task) =>
              task.complexity.displayName == selectedFilter
              || selectedFilter == 'All',
            ).toList(); 
      case 'Priority': return tasks.where( (task) =>
              task.priority.displayName == selectedFilter
              || selectedFilter == 'All',
            ).toList();
      case 'Due Date': 
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final startOfWeek = today.subtract(Duration(days: today.weekday % 7));
            final endOfWeek = startOfWeek.add(const Duration(days: 6));
            final endOfMonth = DateTime(now.year, now.month + 1, 0); // Last day of month
            
            return tasks.where( (task){
              final dueDate = task.dueDate;

              if(selectedFilter == DueBy.overdue.displayName){
                return dueDate.isBefore(today) && !task.isDone;
              }else if(selectedFilter == DueBy.today.displayName){
                return !dueDate.isBefore(today) && !dueDate.isAfter(today);
              }else if(selectedFilter == DueBy.thisWeek.displayName){
                return !dueDate.isBefore(today) && !dueDate.isAfter(endOfWeek);
              }else if(selectedFilter == DueBy.thisMonth.displayName){
                return !dueDate.isBefore(today) && !dueDate.isAfter(endOfMonth);
              }else { return false; }

            })
            .toList();
      default: return tasks;
    }
      
  }

  int nextTaskIndexMax = 0;
  ///Tasks list view
  ///4. This is where a single, (filtered) task list is build
  Widget _buildFilteredTaskList(BuildContext context, List<Task> filteredTasks, String? currentTaskId) {
    int nextTaskIndexCount = 0;

    return SizedBox(
      height: filteredTasks.isEmpty ? 0 : null,
      child: ReorderableListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: (int oldIndex, int newIndex){
          //Before reordering, validate indices so they're not out of bound
          if(oldIndex >= filteredTasks.length || newIndex >= filteredTasks.length){
            return;
          }
          //Handle reordering and update TaskBloc
          if(newIndex > oldIndex){
            newIndex -= 1;
          }
          final tasksCopy = List<Task>.from(filteredTasks);
          final Task item = tasksCopy.removeAt(oldIndex);
          //final Task item = filteredTasks.removeAt(oldIndex);
          tasksCopy.insert(newIndex, item);
          //filteredTasks.insert(newIndex, item);
          context.read<TaskBloc>().add(UpdateTaskOrder(tasksCopy, currentTask ));
          //context.read<TaskBloc>().add(UpdateTaskOrder(filteredTasks, currentTask));
            
          //setState((){}); //Refresh filter display
        },
          
        children: [
          for(final task in filteredTasks)
            ListTile(
              //Drag handle for visual cue
              leading: ReorderableDragStartListener(
                index: filteredTasks.indexOf(task), child: Icon(Icons.drag_handle, color: Colors.grey)
              ),
              key: ValueKey(task.id),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              selectedTileColor: Colors.blue,
              onTap: () {
                Navigator.pushNamed(context,'/editTask', arguments: {'task': task, 'currentTaskId': currentTaskId} as Map<String, dynamic> );
              },
              title: Container(
                //---------------------------
                //Item container background
                //---------------------------
                decoration: BoxDecoration(
                  //---------------------------------------------------
                  // Highlight the pomodoro currentTask and Next Tasks
                  //---------------------------------------------------
                  color: (){
                    if(task.id == currentTaskId){
                      return colorScheme.primary;//Colors.amber;
                    }if(nextTaskIndexCount < 3 && selectedView == "All"){
                      nextTaskIndexCount++;
                      return colorScheme.secondary; //Colors.amber[50];
                    }else{
                      return colorScheme.surface; //Colors.white;
                    }
                  }(),     
                  
                  borderRadius: BorderRadius.circular(5),
                ),
              
                //---------------------------
                //Item row
                //---------------------------
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Left: Item icon and name
                      Row(
                        children: [
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
                                      task.completionRate * 100,
                                  colour: Helper.getColorBasedOnTaskStatus(
                                    task.status,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12),
                          //---------------------------
                          //Item title and stats
                          //---------------------------
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
            
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor:
                                        task.status == TaskStatus.completed
                                        ? Colors.green
                                        : Helper.getColorBasedOnDueDate(
                                            task.dueDate,
                                          ),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "Due ${DateFormat('dd.MM.yy').format(task.dueDate)} index: ${task.orderIndex}",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: colorScheme.onSurface,
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
                                task.duration.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
            
                              Text(
                                "mins",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
            
                          SizedBox(width: 18),
            
                          //Category
                          Icon(categoryNameToIconData[task.category.name] ?? Icons.category, size: 20, color: Color(task.category.color)),  
                        ],
                      ),
                    ], //Big row
                  ),
                ),
              ),
            )
          ]
    )
          );
  }
  
  Padding _introMessage(BuildContext context) {
    return Padding(
      padding:EdgeInsetsGeometry.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/mr_fox00_transparent1.png', scale: 2),
          SizedBox(height: 16),
          Text('No tasks yet', 
            style: TextStyle(fontSize: 24, color: Colors.grey[600])),
          Text('\nOnce you create your tasks, you will be able to view your todo list here and filter your tasks so you can keep track of priorities and deadlines', 
            style: TextStyle(fontSize: 18, color: Colors.grey[700])),
        ]
      ),
    );
  }
  
}
