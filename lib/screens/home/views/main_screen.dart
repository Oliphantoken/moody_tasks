import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainScreen extends StatelessWidget {
  final List<Expense> expenses;
  MainScreen(this.expenses,{super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        
        //Vertically list of things
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShowAppBar(context), //"App Bar" part
      
            const SizedBox(height: 20),
            
            _showCardbox(context), //Card Box
      
            const SizedBox(height: 20),
      
            _showTransactionsTitle(context), //Transactions title row
      
            const SizedBox(height: 5),
      
            _showTransactionsList(context, transactionsData.length),
            
          ]
        
        
        ),
      ),
    );
  }

///App bar are
  Padding _ShowAppBar(BuildContext context){
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
                  Icon(CupertinoIcons.person_fill, color: Colors.yellow[800]),
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
          IconButton(
            icon: Icon(CupertinoIcons.settings),
            onPressed: () {
            },
          ),
      
        ],
      ),
    );
  }

///Card box area
  Container _showCardbox(BuildContext context){
    int totalExpenses = getTotalExpenses(expenses);

    return Container (
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width/2,

      //Background
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [ BoxShadow( blurRadius: 4, color: Colors.grey.shade300, offset: Offset(5, 5) )],
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
          transform: const GradientRotation(pi/4),
        ),
      ),

      //Content
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          const Text("Total Balance", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),
          const Text("£ 4800.00", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w600)),
          SizedBox(height: 5),

          //Income row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row (
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            
                //Income part
                Row (
                  children: [
                    //Down Arrow Icon
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container (
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Colors.greenAccent,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.arrow_down, size: 12),
                        )
                      ),
                    ),
            
                    const SizedBox(width: 8),
            
                    //Income text
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Income", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                        Text("£ 2500.00", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    )
            
                  ]
                ),
            
            
                //Estimations part
                Row (
                  children: [
            
                    //Down Arrow Icon
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container (
                        width: 25,
                        height: 25,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(CupertinoIcons.arrow_down, size: 12),
                        )
                      ),
                    ),
            
                    const SizedBox(width: 8),
            
                    //Income column
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      
                      children: [
                        Text("Expenses", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                        Text('£ $totalExpenses.00', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    )
            
                  ]
                )
              ]
            ),
          )
        ],
      
      ),

    );
  }

///Transactions title row
  Row _showTransactionsTitle(BuildContext context){
    return Row (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
        
            //Transactions title row
            Text("Transactions", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
            //TextButton( onPressed:(){}, child: Text("View All", style: TextStyle(color: Colors.grey, fontSize: 14)) ),
            GestureDetector( onTap:(){}, child: Text("View All", style: TextStyle(fontSize: 14, color: Colors.grey)) ),
          ],
        );
  }

///Transactions list view
  Expanded _showTransactionsList(BuildContext context, int itemCount){
    return Expanded(

      child: ListView.builder(
        itemCount: expenses.length,
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

                        //Icon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container (
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(expenses[i].category.color),//transactionsData[i]["color"],
                                shape: BoxShape.circle
                              ),
                            ),
                            //transactionsData[i]["icon"],
                            Image.asset('assets/icons/${expenses[i].category.icon}.png', scale: 2, color: Colors.white,),
                          ],
                        ),
                    
                        SizedBox(width: 12),
                    
                        //Item name
                        // Text(transactionsData[i]['name'], style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),                   
                        Text(expenses[i].category.name, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),                   
                      ]
                    ),

                    //Right: item cost and date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(transactionsData[i]['totalAmount'], style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        // Text(transactionsData[i]['date'], style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.outline, fontWeight: FontWeight.w500)),
                        Text('${expenses[i].amount.toString()}.00', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
                        Text(DateFormat('dd/MM/yyyy').format(expenses[i].date), style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.outline, fontWeight: FontWeight.w500)),
                        
                      ]
                    ),

                  ], //Big row
                ),

                
              )
              
            ),
          ); 
        
        }
      ),
    );
  }


}

int getTotalExpenses(List<Expense> exp){
    int totalExpenses = 0;
    for(int a=0; a < exp.length; a++){
      totalExpenses+= exp[a].amount;
    }
    return totalExpenses;    
  }