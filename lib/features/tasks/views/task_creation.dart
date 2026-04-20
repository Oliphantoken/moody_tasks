
import 'package:flutter/services.dart';
import 'package:moody_tasks/features/tasks/bloc/task_bloc.dart';
import 'package:moody_tasks/utils/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_repository/domain/Category_Presets.dart';
import 'package:task_repository/domain/entities/category.dart';
import 'package:task_repository/domain/entities/task.dart';
import 'package:task_repository/domain/value_types.dart';
import 'package:uuid/uuid.dart';

enum VALIDATIONTYPE{
  text,
  number,
  date,
}

class TaskCreation extends StatefulWidget {
  const TaskCreation({super.key});

  @override
  State<TaskCreation> createState() => _TaskCreationState();
}

class _TaskCreationState extends State<TaskCreation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  late Task task;
  Category? _selectedCategory;
  Complexity? _selectedComplexity;
  Priority? _selectedPriority;
  bool isLoading = false;

  

  @override
  void initState() {
    dateController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    task = Task.empty;
    _selectedCategory = null;
    _selectedComplexity = Complexity.easy;
    _selectedPriority = null;

    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(

      listener: (context, state) {
        // implement listener for when state changes (save button pressed)
        if(state is TaskSuccess){
          titleController.clear();
          descController.clear();
          durationController.clear();
          categoryController.clear();
          dateController.clear();
        
          //Navigator.pop(context, task);
          Navigator.pop(context, 'goToTaskList');
        }
        else if(state is TaskLoading){
          setState(() {
            isLoading = true;
          });
        }else {
          setState(() {
            isLoading = false;
          });
        }
      },

      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
          ),
          body: _showForm(context),
        ),
      ),
    );
  }

  Widget _showForm(BuildContext context) {
    
    return BlocBuilder<TaskBloc, TaskState>(
      
      builder: (context, state) {
        if (state is TaskSuccess) {
          

          return Form(
            //Form validation
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (){
              setState(() {
                _isFormValid = _formKey.currentState?.validate() ?? false;
              });
            },

            // WRAP your existing form content
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Step 1: Get screen width
                final screenWidth = constraints.maxWidth;
                
                print('Screen width: $screenWidth'); // See this in console!
                
                // Step 2: Decide layout based on width
                //if (screenWidth < 600) {
                  // PHONE LAYOUT (your current design)
                  return _buildPhoneLayout(context);
               // } else {
                  // TABLET LAYOUT (new 2-column design)
                //  return _buildTabletLayout(context);
               // }
              },
            )
          );
        }
        else if (state is TaskFailure) {
          return AppErrorWidget(  // Show error message
            message: state.errorMessage,
            onRetry: () => context.read<TaskBloc>().add(LoadTasks()),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },

    );
  }

  Widget _buildPhoneLayout(BuildContext context){
    return SingleChildScrollView(
    child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 16, 25.0, 32),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
  
        children: [
          //-------------------------
          //INTRO STACK - BG, title, maxTime, due date
          //-------------------------
          Stack(
            children: [
              //BACKGROUND IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/icons/task-background.jpg'), fit: BoxFit.none),
                )
              ),
              //-------------------------
              //INTRO FIELDS
              //-------------------------
              Column(
                children: [
                  //-------------------------
                  //TITLE FIELD
                  //-------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(controller: titleController, maxLines: 2, maxLength: 30, maxLengthEnforcement: MaxLengthEnforcement.enforced, textAlign: TextAlign.center, 
                      validator: (value){
                        if (value == null || value.trim().isEmpty) {
                          return 'Task needs a title!';
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                        ),
                        counterText: "",
                        hintText: "Task name goes here!",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 32),
                        filled: false,
                        fillColor: Colors.grey[200],
                        constraints: BoxConstraints(maxWidth: 150, maxHeight: 150)),
                      )
                  ],),
                SizedBox(height: 16,),
                //-------------------------
                //DURATION AND DUE DATE ROW
                //-------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //-------------------------
                    //DURATION FIELD
                    //-------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Estimated max time", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                        _showTextFormfield(
                          durationController,
                          fieldType: VALIDATIONTYPE.number,
                          0.3,
                          "50",
                          false,
                          10,
                          FontAwesomeIcons.arrowDown,
                          Colors.white,
                          suffixtext: "mins",
                        )
                      ] ,
                    ),
                    //--------------------------
                    //DUE DATE FIELD
                    //--------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Due date", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                        _showTextFormfield(
                          dateController,
                          0.3,
                          "Date",
                          true,
                          12,
                          FontAwesomeIcons.clock, //DATE FIELD
                          Colors.white,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: task.dueDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
              
                            if (newDate != null) {
                              setState(() {
                                dateController.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(newDate);
                                task.dueDate = newDate;
                              });
                            }
                          },
                        ),
                      ] ,
                    ),
                  ],
                ),
              ]),
            ],
          ),
          const SizedBox(height: 8),
          //-------------------------
          //CATEGORY ROW
          //-------------------------
          Text("Category", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _showCategoryItem("Fun", Icon(FontAwesomeIcons.paintbrush), CategoryPresets.fun),
                  _showCategoryItem("Body", Icon(FontAwesomeIcons.personRunning), CategoryPresets.body),
                  _showCategoryItem("Mind", Icon(FontAwesomeIcons.brain), CategoryPresets.mindAndSpirit),
                  _showCategoryItem("Finance", Icon(FontAwesomeIcons.moneyBillWave), CategoryPresets.finance),
                ]
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  _showCategoryItem("Work", Icon(FontAwesomeIcons.wrench), CategoryPresets.professional),
                  _showCategoryItem("Social", Icon(FontAwesomeIcons.peopleGroup),CategoryPresets.social),
                  _showCategoryItem("Home", Icon(FontAwesomeIcons.houseFlag), CategoryPresets.environment),
                ]
              ),
            ],
          ),
          SizedBox(height: 16),
          //-------------------------
          //COMPLEXITY, PRIORITY, STATUS ROW
          //-------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            //-------------------------
            //COMPLEXITY FIELD
            //-------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Complexity", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<Complexity>(
                    initialValue: task.complexity,
                    items: _buildEnumItems(Complexity.values, (c)=>c.displayName),
                    onChanged: (Complexity? c) {
                      if (c != null) {
                        setState(() {
                          _selectedComplexity = c;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.normal)
                    ),
                  ),
                ),
              ],
            ),

            //-------------------------
            //PRIORITY FIELD
            //-------------------------
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Priority", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<Priority>(
                    initialValue: task.priority,
                    items: _buildEnumItems(Priority.values, (p)=>p.displayName),
                    onChanged: (Priority? p) {
                      if (p != null) {
                        setState(() { _selectedPriority = p; });
                      }
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: TextStyle(fontWeight: FontWeight.normal)
                    ),
                  ),
                ),
              ],
            ),
            
          ],),
          SizedBox(height: 16),
          //-------------------------
          //DESCRIPTION FIELD
          //-------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
              TextField(maxLines: 3, maxLength: 90, textAlign: TextAlign.start, controller: descController, decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12)
                ),
                hintText: "In more details...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                filled: true,
                fillColor: Colors.white,
              )
              )
            ]
          ),                  
          const SizedBox(height: 8),
          //--------------------------
          //SAVE BUTTON
          //--------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _showSaveButton("Create new task", 0.4, _isFormValid ? () {
                final newTask = Task(
                  id: const Uuid().v1(),
                  title: titleController.text,
                  description: descController.text,
                  duration: double.parse(( durationController.text != ""? durationController.text : '0')),
                  dueDate: dateController.text != "" ? task.dueDate : DateTime.now().add(Duration(days: 5)),
                  isDone: false,
                  category: _selectedCategory ?? task.category,
                  priority: Priority.low,
                  complexity: Complexity.easy,
                  project: "",
                  tags: [],
                  status: TaskStatus.backlog,
                  completionRate: 0.0,
                  orderIndex: 0,
                  
                );
              
                // Dispatch AddTask event to TaskBloc
                context.read<TaskBloc>().add(AddTask(newTask, ""));
                task = newTask;
              } : null,
              showIsLoading: isLoading),
            ],
          ), //SAVE BUTTON
        ],
      ),
      
    ),
  );
}

  SizedBox _showTextFormfield(
    TextEditingController controller,
    double boxwidth,
    String hinttext,
    bool isreadonly,
    double borderradius,
    IconData prefixicon,
    Color fieldColor, {
    VALIDATIONTYPE? fieldType,
    GestureTapCallback? onTap,
    IconButton? suffixiconbutton,
    String? suffixtext,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * boxwidth,
      height: 40,
      child: TextFormField(
        validator: (value){
          switch(fieldType){
            case VALIDATIONTYPE.text:
              if (value == null || value.trim().isEmpty) {
                return 'This needs a text!';
              } return null;
            case VALIDATIONTYPE.number:
              // Handle null/empty (optional field) - return null (valid)
              if (value == null || value.isEmpty){
                return 'Enter valid duration > 0';
              }
              // Now value is definitely non-null, so parse safely
              final numValue = double.tryParse(value);
              if (numValue == null || numValue <= 0) {
                return 'Enter valid duration > 0';
              }
              return null;

            case VALIDATIONTYPE.date: break;
            default: break;
          }
          return null;
        },
        style: TextStyle(fontSize: 14),
        controller: controller,
        readOnly: isreadonly,
        onTap: onTap,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          suffixIcon: suffixtext != null ? Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 0, vertical: 0), child: TextButton(onPressed: (){}, child: Text(suffixtext, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.normal)))) : suffixiconbutton,//Icon(prefixicon, size: 14, color: Colors.grey),//suffixiconbutton,
          filled: true,
          fillColor: fieldColor,
          hintText: hinttext,
          hintStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderradius),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  ///This method shows a Save button, used in both the screen and the followup modals
  SizedBox _showSaveButton(
    String buttontext,
    double size,
    Function()? onpressed, {
    bool showIsLoading = false,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * size,
      height: 45,
      child: showIsLoading
          ? const Center(child: CircularProgressIndicator())
          : TextButton(
              onPressed: onpressed,
              style: TextButton.styleFrom(
                backgroundColor: onpressed != null ? Colors.grey[700] : Colors.grey[300],
                foregroundColor: onpressed != null ? Colors.white : Colors.grey[500],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttontext,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
    );
  }

  Container _showCategoryItem(String label, Icon categoryIcon, Category category, {var onpressed}){
    final bool isSelected = _selectedCategory?.categoryType == category.categoryType;
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: isSelected ? Colors.black87 : Colors.white,
        border: Border.all(color: isSelected ? Colors.black87 : Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          IconButton(
            icon: categoryIcon,
            iconSize: 26,
            color: isSelected ? Colors.white : Colors.black,
            padding: EdgeInsets.only(bottom: 0),
            onPressed: onpressed?? () {
              setState(() {
                _selectedCategory = category;              
              });
            },
          ),
          Text(label, style: TextStyle(height: 0, fontSize: 11, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
        ]
      ),
    );
  }
  

  List<DropdownMenuItem<Complexity>> _buildComplexityItems(){
    return Complexity.values.map((c){

      return DropdownMenuItem<Complexity>(
        value: c,
        child: Text(c.displayName),
      );

    }).toList(growable: false);
  }


  List<DropdownMenuItem<T>> _buildEnumItems<T>(List<T> values, String Function(T) displayName){
    return values
    .map((v){ return DropdownMenuItem(value: v, child: Text( displayName(v) )); })
    .toList();
  }
   



   Widget _buildTabletLayout(BuildContext context){
    return SingleChildScrollView(
    child: Padding(
        padding: EdgeInsets.fromLTRB(25.0, 16, 25.0, 32),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
  
        children: [
          //-------------------------
          //INTRO STACK - BG, title, maxTime, due date
          //-------------------------
          Stack(
            children: [
              //BACKGROUND IMAGE
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/icons/task-background.jpg'), fit: BoxFit.contain),
                )
              ),
              //-------------------------
              //INTRO FIELDS
              //-------------------------
              Column(
                children: [
                  //-------------------------
                  //TITLE FIELD
                  //-------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(controller: titleController, maxLines: 2, maxLength: 30, maxLengthEnforcement: MaxLengthEnforcement.enforced, textAlign: TextAlign.center, 
                      validator: (value){
                        if (value == null || value.trim().isEmpty) {
                          return 'Task needs a title';
                        }
                        return null;
                      },

                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none
                        ),
                        counterText: "",
                        hintText: "Task name goes here!",
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        contentPadding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 32),
                        filled: false,
                        fillColor: Colors.grey[200],
                        constraints: BoxConstraints(maxWidth: 150, maxHeight: 150)),
                      )
                  ],),
                SizedBox(height: 16,),
                //-------------------------
                //DURATION AND DUE DATE ROW
                //-------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //-------------------------
                    //DURATION FIELD
                    //-------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Estimated max time", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                        _showTextFormfield(
                          durationController,
                          fieldType: VALIDATIONTYPE.number,
                          0.3,
                          "50",
                          false,
                          10,
                          FontAwesomeIcons.arrowDown,
                          Colors.white,
                          suffixtext: "mins",
                        )
                      ] ,
                    ),
                    //--------------------------
                    //DUE DATE FIELD
                    //--------------------------
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Due date", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
                        _showTextFormfield(
                          dateController,
                          0.3,
                          "Date",
                          true,
                          12,
                          FontAwesomeIcons.clock, //DATE FIELD
                          Colors.white,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: task.dueDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
              
                            if (newDate != null) {
                              setState(() {
                                dateController.text = DateFormat(
                                  'dd/MM/yyyy',
                                ).format(newDate);
                                task.dueDate = newDate;
                              });
                            }
                          },
                        ),
                      ] ,
                    ),
                  ],
                ),
              ]),
            ],
          ),
          const SizedBox(height: 8),
            //-------------------------
          //CATEGORY ROW
          //-------------------------
          Text("Category", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 16,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _showCategoryItem("Fun", Icon(FontAwesomeIcons.paintbrush), CategoryPresets.fun),
                  _showCategoryItem("Body", Icon(FontAwesomeIcons.personRunning), CategoryPresets.body),
                  _showCategoryItem("Mind", Icon(FontAwesomeIcons.brain), CategoryPresets.mindAndSpirit),
                  _showCategoryItem("Finance", Icon(FontAwesomeIcons.moneyBillWave), CategoryPresets.finance),
                  _showCategoryItem("Work", Icon(FontAwesomeIcons.wrench), CategoryPresets.professional),
                  _showCategoryItem("Social", Icon(FontAwesomeIcons.peopleGroup),CategoryPresets.social),
                  _showCategoryItem("Home", Icon(FontAwesomeIcons.houseFlag), CategoryPresets.environment),
                ]
              ),
            ],
          ),
          SizedBox(height: 16),
          
          //-------------------------
          //COMPLEXITY, PRIORITY, STATUS ROW
          //-------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            //-------------------------
            //COMPLEXITY FIELD
            //-------------------------
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Complexity", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                DropdownButton(
                  value: task.complexity,
                  items: _buildComplexityItems(),
                  onChanged:(value) => _selectedComplexity = value,
                  isExpanded: true,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  underline: Container(),
                ),
              ],
            ),
            //-------------------------
            //PRIORITY FIELD
            //-------------------------
            Container(
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text("Priority", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
                  TextButton(style: TextButton.styleFrom(backgroundColor: Colors.white, fixedSize: Size(90, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("Low", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)), onPressed: (){}, ),
                ],
              ),
            ),
            
          ],),
          SizedBox(height: 16),
          //-------------------------
          //DESCRIPTION FIELD
          //-------------------------
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Description", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold),),
              TextField(maxLines: 3, maxLength: 90, textAlign: TextAlign.start, controller: descController, decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12)
                ),
                hintText: "In more details...",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
                filled: true,
                fillColor: Colors.white,
              )
              )
            ]
          ),                  
          const SizedBox(height: 8),
          //--------------------------
          //SAVE BUTTON
          //--------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _showSaveButton("Create new task", 0.4, _isFormValid ? () {
                final newTask = Task(
                  id: const Uuid().v1(),
                  title: titleController.text,
                  description: descController.text,
                  duration: double.parse(( durationController.text != ""? durationController.text : '0')),
                  dueDate: dateController.text != "" ? task.dueDate : DateTime.now().add(Duration(days: 5)),
                  isDone: false,
                  category: _selectedCategory ?? task.category,
                  priority: _selectedPriority ?? task.priority,
                  complexity: _selectedComplexity ?? task.complexity,
                  project: "",
                  tags: [],
                  status: TaskStatus.backlog,
                  completionRate: 0.0,
                  orderIndex: 0,                  
                );
              
                // Dispatch AddTask event to TaskBloc
                context.read<TaskBloc>().add(AddTask(newTask, ""));
                task = newTask;
              } : null,
              showIsLoading: isLoading),
            ],
          ), //SAVE BUTTON
        ],
      ),
      
    ),
  );
}

  
}
