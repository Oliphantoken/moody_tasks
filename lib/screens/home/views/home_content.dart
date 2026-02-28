import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:moody_tasks/features/tasks/bloc/task_bloc.dart';
import 'package:task_repository/domain/entities/task.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        print(
          "HomeContent rebuild - tasks: ${(state is TaskSuccess) ? state.tasks.length : 'none'}",
        );
        List<Task> tasks = [];
        if (state is TaskSuccess) tasks = state.tasks;

        if(tasks.isEmpty){
          return SafeArea(
          child: Center( child: Text('Welcome'))
          );
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
        
                //_showCardbox(context), //Card Box
                const SizedBox(height: 20),
        
                _showTasksTitle(context, tasks), //Tasks title row
                
        
                const SizedBox(height: 5),
        
                _showTaskList(context, tasks),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Left side: Profile row
          Row(
            children: [
              //Profile Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  //Bg circle
                  Container( width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.yellow[700],)),
                  //Profile icon
                  Icon(Icons.person, color: Colors.yellow[800]),
                ],
              ),

              //Column for vertical text order
              Column(
                children: [
                  //Greeting
                  Text("Welcome!", style: TextStyle( fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.outline)),
                  Text("John Doe!", style: TextStyle( fontSize: 18, fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSurface)),
                ]
              ),
            ],
          ),

          //Right side: action buttons
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
    );
  }

/*Card box area
  Container _showCardbox(BuildContext context) {
    int totalExpenses = 1000; //getTotalExpenses(tasks);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width / 2,

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

      //Content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          const Text(
            "Total Balance",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          const Text(
            "£ 4800.00",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),

          //Income row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Income part
                Row(
                  children: [
                    //Down Arrow Icon
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_downward, size: 12),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    //Income text
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Income",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "£ 2500.00",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //Estimations part
                Row(
                  children: [
                    //Down Arrow Icon
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.arrow_downward, size: 12),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    //Income column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Expenses",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '£ $totalExpenses.00',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
*/

  ///Task title row
  Row _showTasksTitle(BuildContext context, List<Task> tasks) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Tasks title row
        GestureDetector(
          onTap: () {
            context.read<TaskBloc>().add(DeleteTask(tasks[0].id, ""));
          },
          child: Text(
            "Tasks",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        GestureDetector(
          onTap: () {
            for (var task in tasks) {
              print('Task: ${task.title}, Due Date: ${task.dueDate}');
            }
          },
          child: Text(
            "View All",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  ///Task list view
  Widget _showTaskList(BuildContext context, List<Task> tasks) {
    return Expanded(
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, int i) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),

            //Container for each list item
            child: Container(
              //Item container background
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),

              //Item row
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Left: Item icon and name
                    Row(
                      children: [
                        //Progress Icon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors
                                    .blueGrey, // Color(tasks[i].category.color),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(
                              tasks[i].duration.toString(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //transactionsData[i]["icon"],
                            //Image.asset('assets/icons/${expenses[i].category.icon}.png', scale: 2, color: Colors.white,),
                          ],
                        ),

                        SizedBox(width: 12),

                        //Item title and stats
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tasks[i].title,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  tasks[i].duration.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  tasks[i].duration.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  tasks[i].duration.toString(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    //Right: item cost and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(transactionsData[i]['totalAmount'], style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        Text(
                          DateFormat('dd/MM/yyyy').format(tasks[i].dueDate),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.outline,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ], //Big row
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  int getTotalExpenses(List<Task> exp) {
    int totalExpenses = 0;
    for (int a = 0; a < exp.length; a++) {
      //totalExpenses+= exp[a].amount;
    }
    return totalExpenses;
  }
}
