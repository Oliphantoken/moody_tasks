import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      
      //Vertically list of things
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //"App Bar" part
          Row(
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

          //Card Box
          Container (
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width/2,
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          )

        ]
      
      
      ),
    );
  }

}