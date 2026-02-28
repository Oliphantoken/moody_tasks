
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sentiment_very_dissatisfied, size: 100, color: Colors.grey),
              SizedBox(height: 24),
              Text('Something went wrong', 
                style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8),
              Text('Please restart the app', 
                style: TextStyle(color: Colors.grey[600])),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), // Close app
                child: Text('Close App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
