import 'dart:math';

import 'package:moody_tasks/screens/stats/chart.dart';
import 'package:flutter/material.dart';

class StatScreen extends StatelessWidget {
  const StatScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    bool isExpensesBtn = true;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions", style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_outlined)),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              //Buttons row: Income/Expenses
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(12))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                  
                      //Income button
                      Container(
                        decoration: //isExpensesBtn ?
                        BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        // :BoxDecoration(
                        //   color: Colors.red,
                        //   borderRadius: BorderRadius.all(Radius.circular(12))
                        // ),
                      
                        child: TextButton(
                          onPressed: () {
                            isExpensesBtn != isExpensesBtn;
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black, // Text/icon color
                            backgroundColor: Colors.white, // Button background color
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          child: const Text('Income'),
                        ),
                      ),
                  
                      //Expense button
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.tertiary,
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.primary,
                            ],
                            transform: const GradientRotation(pi/40),
                          ),
                            borderRadius: BorderRadius.all(Radius.circular(12))
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white, // Text/icon color
                            //backgroundColor: Colors.blue, // Button background color
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text('Expenses'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),

                //Show Chart
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
                  child: const MyChart(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
