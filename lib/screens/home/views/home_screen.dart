import 'dart:math';
import 'package:expense_repository/expense_repository.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:expense_tracker/screens/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:expense_tracker/screens/stats/stats_screen.dart';
import 'package:expense_tracker/screens/add_expense/views/add_expense.dart';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../add_expense/blocs/get_expenses_bloc/get_expenses_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int screenIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if(state is GetExpensesSuccess){
          return Scaffold(
            body: [
              //Instead of a switch statement, will go through incrementally
              MainScreen(state.expenses),
              const StatScreen(),
            ][screenIndex],

            //Bottom Nav Bar
            bottomNavigationBar: _drawBottomNavigationBar(context),

            //Bottom Add button
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: _drawFloatingActionButton(context, state),
          );
        }
        else{
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
      },
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
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),

          //Stats button
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square_fill),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  ///Floating Action Button
  Container _drawFloatingActionButton(BuildContext context, GetExpensesSuccess state) {
    return Container(
      width: 50,
      height: 50,

      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {

          var newExpense = await Navigator.push(
            context,
            MaterialPageRoute<Expense>(
              builder: (BuildContext context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) =>
                        CreateCategoryBloc(FirebaseExpenseRepo()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        GetCategoriesBloc(FirebaseExpenseRepo())
                          ..add(GetCategories()),
                  ),
                  BlocProvider(
                    create: (context) =>
                        CreateExpenseBloc(FirebaseExpenseRepo()),
                  ),
                ],
                child: const AddExpense(),
              ),
            ),
          );

          if(newExpense != null){
            setState(() {
              state.expenses.insert(0, newExpense);
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
                Theme.of(context).colorScheme.tertiary,
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.primary,
              ],
              transform: const GradientRotation(pi / 4),
            ),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
    );
  }
}

//
