import 'dart:math';
import 'package:expense_tracker/screens/home/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),

      body: const MainScreen(),

      //Bottom Nav Bar
      bottomNavigationBar: _drawBottomNavigationBar(context),

      //Bottom Add button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _drawFloatingActionButton(context)


    );
  }

  ///Bottom Navigation Bar
  ClipRRect _drawBottomNavigationBar(BuildContext context){
    return ClipRRect (

      borderRadius: BorderRadius.vertical (
        top: Radius.circular(30)
      ),

      child: BottomNavigationBar (
        backgroundColor: Colors.white,
        elevation: 3,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [

          //Home button
          BottomNavigationBarItem (
            icon: Icon(CupertinoIcons.home),
            label: 'Home'
          ),
      
          //Stats button
          BottomNavigationBarItem (
            icon: Icon(CupertinoIcons.graph_square_fill),
            label: 'Stats'
          ),
        
        ]
      ),
    );
  }

  ///Floating Action Button
  Container _drawFloatingActionButton(BuildContext context){
    return Container(
      width: 50,
      height: 50,

      child: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: (){},  // Add action here!
      
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
              transform: const GradientRotation(pi/4),
            ),
          ),
          child: const Icon(
            CupertinoIcons.add
            ),
        ),
        ),
    );
  }

}

//