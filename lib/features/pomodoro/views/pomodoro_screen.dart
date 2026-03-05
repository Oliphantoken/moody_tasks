import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moody_tasks/config/injection.dart';
import 'package:moody_tasks/features/tasks/bloc/task_bloc.dart';
import 'package:moody_tasks/screens/home/views/main_layout.dart';
import 'package:moody_tasks/utils/pomodoro_FSM.dart';
import 'package:pomodoro_repository/domain/repositories/pomodoro_repository_abstract.dart';
import 'package:task_repository/domain/entities/task.dart';
import 'dart:async';

import 'package:task_repository/domain/value_types.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}



class _PomodoroScreenState extends State<PomodoroScreen> with WidgetsBindingObserver {
  String _currentTaskID = '';
  late final PomodoroRepository _pomoRepo;
  /// Track completed pomodoros per task
  Map<String, int> _completedPomodoros = {}; // task.id -> count

  //Data flow management
  bool _hasLoadedFromRepo = false;
  bool _isPomodorosListValid = false;
  bool _isValidatingPomodoros = false;
  bool _isCompletedPomodorosListValidated = false;

  ///Set durations in seconds (durInMins x 60)
  final _stateMachine = PomodoroStateMachine(
    pomodoroDuration: 25 * 60,
    shortBreakDuration: 5 * 60,
    longBreakDuration: 30 * 60,
  );
  int _currentModeDuration = 25 * 60;  // 25 minutes
  Timer? _timer;
  bool _isRunning = false;
  bool _isPaused = false;

  
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);  //Listen for app lifecycle
    _pomoRepo = getIt<PomodoroRepository>();
  }

  //Method for when navigating between screens
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_hasLoadedFromRepo) return;
    _hasLoadedFromRepo = true;
    _loadPomodoroState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        print("Pomodoro rebuild - tasks: ${(state is TaskSuccess) ? state.tasks.length : 'none'}",);
        
        List<Task> tasks = [];
        Task currentTask;
        List<Task> nextTasks = [];
        if (state is TaskSuccess){
          tasks = state.tasks;
        }

        //1. If no tasks
        if(state is! TaskSuccess || tasks.isEmpty){
          return SafeArea(
            child: Center( child: Text('Hi there!\nCreate a task and start working on it!'))
          );
        }
        
        //2. Async to validate pomodoros state
        if(!_isValidatingPomodoros && tasks.isNotEmpty && !_isCompletedPomodorosListValidated){
          _isValidatingPomodoros = true;

          Future.microtask(() async {
            final valid = await _validateAllPomodoros(tasks);

            if(!mounted) return;

            setState(() {
              _isPomodorosListValid = valid;
              _isCompletedPomodorosListValidated = true;
              _isValidatingPomodoros = false;
            });
            context.read<TaskBloc>().add(SetCurrentTask(_currentTaskID));
            
          });
        }
        //3.While validation is still running
        if(_isValidatingPomodoros || !_isCompletedPomodorosListValidated){
          return SafeArea(child: Center(child: Text('Wait for it...'),));
        }

        //4. Success - validation is done, build currentTask and nextTasks      

        //4.1. Set current task from memory or first task in list
        currentTask = tasks.firstWhere((t)=> t.id == _currentTaskID,
                      orElse: (){ _currentTaskID = tasks[0].id; return tasks[0]; });
        
        MainLayout.currentTask = currentTask.id;
        
        //4.2.a Is the _completedPomodoros list valid?
        if(_isPomodorosListValid){

          //Populate the next tasks list with tasks that have the same ID as the ones in memory
          // Skip the current task. The orElse statement should virtually never run,
          // due to the previous validation.
          _completedPomodoros.forEach((key, value) {
            if (key != _currentTaskID) {
              final t = tasks.firstWhere( (t) => t.id == key,
                orElse: () { print("Build: problem populating next task list!"); return Task.empty; },
              );
              if (t != Task.empty && nextTasks.length < 4) {
                nextTasks.add(t);
              }
            }
          });
        }
        //4.2.b The list is empty or corrupted somehow
        else {
          //Use the tasks list to populate the screen
          nextTasks = [
            for(int i = 0; i < tasks.length; i++)
              if(tasks[i].id != _currentTaskID)
                tasks[i] 
          ].take(3).toList();

        }
        

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
        
            //Vertically list of things
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _showAppBar(context), //"App Bar" part
                const SizedBox(height: 20),

                _showLabel("Current Task", 14),
                const SizedBox(height: 8),

                _showTaskAndTimerBubble(context, currentTask),
                const SizedBox(height: 24),
        
                _showLabel("Next Task", 12),
                const SizedBox(height: 4),

                _showNextTasksList(context, tasks, nextTasks),
              ],
            ),
          ),
        );
      },
    );
  }

  ///App bar area
  Padding _showAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Center: title
          Text("Pomodoro - Focus Technique", style: TextStyle(fontSize: 16, )),
        ],
      ),
    );
  }

  Widget _showLabel(String text, double fontsize) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }


  Widget _showTaskAndTimerBubble(BuildContext context, Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(48),
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row with task details + Start/Pause
          _buildTaskHeaderRow(context, task),

          // Big centered timer underneath
          _buildTimer(context),

          // Pomodoro buttons at the end
          _buildPomodoroButtons(context),
        ],
      ),
    );
  }

  Widget _buildTaskHeaderRow(BuildContext context, Task task) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: title + due date
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Due: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 2),

              //Pomodoro count chip
              GestureDetector(
                onTap: () {
                  _setCompletedPomodoros(task.id, 1);
                  _saveTaskState(task, false);
                },
                onLongPress: () {
                  _setCompletedPomodoros(task.id, -1);
                  _saveTaskState(task, false);
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${_getCompletedPomodoros(task.id)}/${_getPomodorosNeeded(task)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),

        const SizedBox(width: 12),

        //-----------------------------  
        // RIGHT: Start/Pause button + isDone
        //-----------------------------
        ElevatedButton(
          onPressed: task.isDone ? null : (){ 
            if(_isRunning){ _isPaused = true; }
            _toggleTimer(task.id);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isRunning ? Colors.grey[800] : Colors.grey[300],
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(70, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30)),
            ),
          ),
          child: Text(
            _isRunning ? 'Pause' : 'Start',
            style: TextStyle(fontSize: 14, color: _isRunning ? Colors.white : Colors.black87),
          ),
        ),

        const SizedBox(width: 4),

        //ISDONE BUTTON
        ElevatedButton (
          onPressed: (){
            _saveTaskState(task, true);
            
            // 2. Stop current timer
            _timer?.cancel();
      
            // 3. Update current index and reset timer state
            setState(() {
              _isRunning = false;
              _currentModeDuration = _stateMachine.pomodoroDuration;
              //Maybe reset pomodoros for new task?
              //_completedPomodoros.remove(task.id)
            });
             
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: task.isDone ? Colors.green : Colors.amber,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            minimumSize: const Size(70, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            ),
          ),
          child: Text(task.isDone ? 'Not done?' : 'Done', style: TextStyle(fontSize: 14, color: Colors.black87)),
        )
      ],
    );
  }

  Widget _buildTimer(BuildContext context) {
    final minutes = (_currentModeDuration ~/ 60).toString().padLeft(2, '0');
    final seconds = (_currentModeDuration % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Center(
        child: Text(
          '$minutes:$seconds',
          style: TextStyle(
            fontSize: 100,              // Bigger timer
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            color: Colors.grey[800],
          ),
        ),
      ),
    );
  }

  ///Toggle Start/Pause timer
  void _toggleTimer(String currentTaskId) {
    //If timer is running, cancel the async function and return;
    if (_isRunning) {
      _timer?.cancel();
      setState(() {
        _isRunning = false;
      });
      return;
    }

    //If _isRunning is FALSE:

    //Unless you've paused, start timer with FSM-aware duration
    if(!_isPaused){
      _currentModeDuration = _stateMachine.currentDuration;
    }else{  //Otherwise reset pause
      _isPaused = false;
    }
    
    //_timer is not the seconds but the async function.
    // For every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async{
      
      // ---------------------------
      // COUNT DOWN
      // ---------------------------
      if(_currentModeDuration > 0){
        setState(() {
          _currentModeDuration--;
        });
      }
      // ---------------------------
      // TIME'S UP
      // ---------------------------
      else {
        //1. Increment pomodoros only during pomodoro mode
        if(_stateMachine.currentMode == PomodoroMode.pomodoro){
          await _setCompletedPomodoros(currentTaskId, 1);
        }
        //2. For future: show completion UI, add sfx etc
        _showCycleComplete();

        //3. Advance FSM
        _stateMachine.completeCycle();

        //4. Reset timer to next mode
        setState(() {
          _currentModeDuration = _stateMachine.currentDuration;
        });

      }
    });

    setState(() {
      _isRunning = true;
    });

  }


  Widget _buildPomodoroButtons(BuildContext context) {
  final current = _stateMachine.currentMode;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _pomodoroModeButton('Short break', current == PomodoroMode.shortBreak),
      _pomodoroModeButton('Pomodoro', current == PomodoroMode.pomodoro),
      _pomodoroModeButton('Long break', current == PomodoroMode.longBreak),
    ],
  );
}

  Widget _pomodoroModeButton(String label, bool isActive) {
    return TextButton(
      onPressed: (){
        //1. Stop timer
        _timer?.cancel();

        //2. Switch FSM mode
        if(_stateMachine.setCurrentMode(label.toLowerCase())){
          setState(() {
            _currentModeDuration = _stateMachine.currentDuration;
            _isRunning = false;
            _isPaused = false;          
          });
          
        }
      },
      style: TextButton.styleFrom(
        backgroundColor: isActive ? Colors.grey[800] : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ), 
      child: Text(
        label,
        style: TextStyle(
          fontSize: isActive ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.white : Colors.grey[600],
        ),
      ),
    );
  }


  Widget _showNextTasksList(BuildContext context, List<Task> tasks, List<Task> nextTasks) {
    if (nextTasks.isEmpty) {
      return Text(
        'No more tasks in the queue.',
        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: nextTasks.length,
        itemBuilder: (context, index) {
          Task task = nextTasks[index];

          return GestureDetector(
            onLongPress: () => Navigator.pushNamed(context,'/editTask', arguments: task ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              leading: IconButton(
                onPressed: () {
                  //Toggle isDone ->update CompletionRate And Status, copy all variables to another object before using TaskBloc
                  _saveTaskState(task, true);
                },
                icon: Icon(Icons.check_circle, size: 32, color: task.isDone ? Theme.of(context).colorScheme.primary : Colors.grey,),
              ),
              //--------------
              // NEXT TASK TITLE
              //--------------
              title: TextButton(
                //Switch to being Current Task
                onPressed: () {
                  //Deactivated if task is completed
                  if(task.isDone){
                    return;
                  }

                 // 1. Stop current timer
                  _timer?.cancel();
              
                  // 3. Update current index and reset timer state
                  setState(() {
                    _currentTaskID = task.id;
                    _isRunning = false;
                    _currentModeDuration = _stateMachine.pomodoroDuration;
                    //Maybe reset pomodoros for new task?
                    //_completedPomodoros.remove(task.id)
                  });
                  context.read<TaskBloc>().add(SetCurrentTask(task.id));
                },
                
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                  padding: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.centerLeft,                  
                ),
                //-----------------
                // TITLE AND DUE DATE
                //-----------------
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: task.isDone ? FontWeight.normal : FontWeight.w500,
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),

                    Text('Due: ${DateFormat('dd/MM/yyyy').format(task.dueDate)}',
                      style: TextStyle(
                        fontSize: 12, 
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        color:  Colors.grey[800],
                        )
                    ),
                  ],
                ),
              ),

              //POMODORO COUNTER
              trailing: GestureDetector(
                onTap: () {
                  _setCompletedPomodoros(task.id, 1);
                  _saveTaskState(task, false);
                },
                onLongPress: () {
                   _setCompletedPomodoros(task.id, -1);
                  _saveTaskState(task, false);
                },
                
                child: Text(
                  '[${_getCompletedPomodoros(task.id)}/${_getPomodorosNeeded(task)}]',
                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                ),
              ),            
            ),
          );
        },
      ),
    );
    }

  //---------------------------------
  // Pomodoro functions
  //---------------------------------

  int _getPomodorosNeeded(Task task) {
    // task.duration is in minutes
    return (task.duration / (_stateMachine.pomodoroDuration/60)).ceil();
  }

  int _getCompletedPomodoros(String taskId) {
    return _completedPomodoros[taskId] ?? 0;
  }

  Future<int> _setCompletedPomodoros(String currentTaskId, int value) async {
      final newCount = (_completedPomodoros[currentTaskId] ?? 0) + value;
      
      //UI update
      setState(() {
        _completedPomodoros[currentTaskId] = newCount;
      });
      return newCount;      
  }

  Future<bool> _validateAllPomodoros(List<Task> originalTasks) async {
    try {

      // 1. If empty, nothing to validate
      if (_completedPomodoros.isEmpty) {
        return false;
      }

      final removeList = <String>[];

      // 2. For each pomodoro task, check if it still exists in tasks.
      // If not, mark its id for removal.
      _completedPomodoros.forEach((key, value) {
        originalTasks.firstWhere(
          (e) => e.id == key,
          orElse: () {
            removeList.add(key);
            return Task.empty;
          },
        );
      });

      // 3. Remove invalid pomodoros from repo + local map
      for (final taskId in removeList) {
        //await _deletePomodoroCount(taskId);
        _completedPomodoros.remove(taskId);
      }

      // 4. If after cleaning it's empty, return false
      if (_completedPomodoros.isEmpty){
        return false;
      }

      // 5. Ensure _currentTaskID is valid
      if (_currentTaskID.isEmpty ||
          !_completedPomodoros.keys.contains(_currentTaskID)) {
            _currentTaskID = _completedPomodoros.keys.first;
      }

      
      return true;
    } catch (e) {
      print("Something went wrong with validating all pomodoro task IDs: $e");
      _isPomodorosListValid = false;
      return false;
    }
  }


  void _showCycleComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_stateMachine.currentMode.name.toUpperCase()} complete!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  //Method for when navigating between screens
  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _savePomodoroState();
    super.dispose();
  }

  //Method for when app lifecycle is changed (app minimised etc)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.hidden){
      _savePomodoroState();
    }
  }

  Future<void> _loadPomodoroState() async {
    try {
      final state = await _pomoRepo.loadPomodoroState();
      if(state != null && mounted){
        setState(() {
          _currentTaskID = state.keys.first;
          _completedPomodoros = state;
        });  
      }   
    } catch (e) { print('Problem loading state into Pomodoro screen: $e'); }
    
  }

  Future<void> _savePomodoroState() async {
    try{
      await _pomoRepo.savePomodoroState(_completedPomodoros, _currentTaskID);
      print('✅ Pomodoro state saved');

    }catch(e){ print('Failed to save Pomodoro state: $e'); }
  }

  Future<void> _saveTaskState(Task task, bool toggleIsDone) async {
    try{
      //2. if task isn't empty, make an updated copy of it
      if(task != Task.empty){
        bool isdone = task.isDone;
        if(toggleIsDone){
          isdone = !isdone;
        }

        final completionRate = isdone? 1.0 : (_getCompletedPomodoros(task.id)/_getPomodorosNeeded(task)).clamp(0.0, 1.0);
        final newStatus = isdone ? TaskStatus.completed : completionRate >= 0.8 
        ? TaskStatus.inreview 
        : completionRate > 0 
          ? TaskStatus.inprogress 
          : TaskStatus.todo;
      
        final updatedTask = task.copyWith(
          isDone: isdone,
          completionRate: completionRate,
          status: newStatus,
        );

        //3. Update task through BLoC
        context.read<TaskBloc>().add(UpdateTask(updatedTask, _currentTaskID));
      }
      print('✅ Tasklist state saved');

    }catch(e){ print('Failed to save tasklist state: $e'); }
  }

}
