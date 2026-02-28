import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_repository/domain/entities/task.dart';
import 'package:task_repository/domain/entities/category.dart';

List<Map<String, dynamic>> transactionsData = [
  {
    'color': Colors.yellow[700],
    'icon': const FaIcon(FontAwesomeIcons.burger, color: Colors.white),
    'name': 'Food',
    'totalAmount': '-£45.00' ,
    'date': 'Today'
  },

  {
    'color': Colors.purple,
    'icon': const FaIcon(FontAwesomeIcons.bagShopping, color: Colors.white),
    'name': 'Shopping',
    'totalAmount': '-£276.00' ,
    'date': 'Today'
  },

  {
    'icon': const FaIcon(FontAwesomeIcons.heartCircleCheck, color: Colors.white),
    'color': Colors.green,
    'name': 'Health',
    'totalAmount': '-£79.00' ,
    'date': 'Today'
  },

  {
    'icon': const FaIcon(FontAwesomeIcons.plane, color: Colors.white),
    'color': Colors.blue,
    'name': 'Travel',
    'totalAmount': '-£821.00' ,
    'date': 'Yesterday'
  },

  {
    'icon': const FaIcon(FontAwesomeIcons.receipt, color: Colors.white),
    'color': Colors.deepOrange,
    'name': 'Bills',
    'totalAmount': '-£1267.00' ,
    'date': 'Yesterday'
  },

];


final List<Task> tasklistData = [
//   Task(orderIndex: 0, id: "0", title: "Mopping floor", description: "Spring cleaning", dueDate: DateTime.now().add(const Duration(days: 10)), category: Category(categoryID: "1", name: "Personal", color: 0xfff44336),
//       duration: 5.0, priority: Priority.low , complexity: Complexity.moderate, project: "House Chores", tags: ["chores", "home"], status: TaskStatus.todo, completionRate: 0.0),
//   Task(orderIndex: 1, id: "1", title: "Laundry", description: "Put the laundry in a black bin bag", dueDate: DateTime.now().add(const Duration(days: 5)), category: Category(categoryID: "1", name: "Personal", color: 0xfff44336),
//       duration: 2.5, priority: Priority.low , complexity: Complexity.moderate, project: "House Chores", tags: ["chores", "home"], status: TaskStatus.todo, completionRate: 0.0),
//   Task(orderIndex: 2, id: "2", title: "Clean up", description: "Clean the house", dueDate: DateTime.now(), category: Category(categoryID: "1", name: "Personal", color: 0xfff44336),
//       duration: 1.0, priority: Priority.medium, complexity: Complexity.easy, project: "House Chores", tags: ["chores", "home"], status: TaskStatus.inprogress, completionRate: 0.10),
//   Task(orderIndex: 3, id: "3", title: "Prepare car", description: "Get car and load it with with all boxes", dueDate: DateTime.now().add(const Duration(days: 2)), category: Category(categoryID: "1", name: "Personal", color: 0xfff44336),
//       duration: 0.5, priority: Priority.low, complexity: Complexity.complex, project: "Flutter", tags: ["chores", "work"], status: TaskStatus.inprogress, completionRate: 0.53),
//   Task(orderIndex: 4, id: "4", title: "Dishwashing", description: "everything", dueDate: DateTime.now().add(const Duration(days: 7)), category: Category(categoryID: "6", name: "Finance", color: 0xff9c27b0),
//       duration: 1.5, priority: Priority.medium, complexity: Complexity.easy, project: "House Chores", tags: ["chores", "home"], status: TaskStatus.completed, completionRate: 0.99),
//   Task(orderIndex: 5, id: "5", title: "Sweeping", description: "Floor", dueDate: DateTime.now().add(const Duration(days: 2)), category: Category(categoryID: "5", name: "Spirituality", color: 0xff3f51b5),
//       duration: 1.0, priority: Priority.low, complexity: Complexity.easy, project: "House Chores", tags: ["chores", "home"], status: TaskStatus.inreview, completionRate: 0.87),
//   Task(orderIndex: 6, id: "6", title: "Swimming", description: "Go to the local pool for a swim", dueDate: DateTime.now().subtract(const Duration(days: 2)), category: Category(categoryID: "2", name: "Health", color: 0xff4caf50),
//       duration: 1.0, priority: Priority.low, complexity: Complexity.complex, project: "Health", tags: ["health", "exercise"], status: TaskStatus.backlog, completionRate: 0.0),
//   Task(orderIndex: 7, id: "7", title: "Grocery shopping", description: "Get groceries for the week", dueDate: DateTime.now().add(const Duration(days: 1)), category: Category(categoryID: "2", name: "Health", color: 0xff4caf50),
//       duration: 1.5, priority: Priority.medium, complexity: Complexity.moderate, project: "Errands", tags: ["shopping", "errands"], status: TaskStatus.inprogress, completionRate: 0.25),
//   Task(orderIndex: 8, id: "8", title: "Project meeting", description: "Discuss project requirements with the team", dueDate: DateTime.now().add(const Duration(days: 5)), category: Category(categoryID: "4", name: "Career", color: 0xff2196f3),
//       duration: 2.0, priority: Priority.high, complexity: Complexity.complex, project: "Work", tags: ["meeting", "work"], status: TaskStatus.todo, completionRate: 0.0),
//   Task(orderIndex: 9, id: "9", title: "Duaa session", description: "Attend a religion class", dueDate: DateTime.now(), category: Category(categoryID: "5", name: "Spirituality", color: 0xff3f51b5),
//       duration: 1.0, priority: Priority.low, complexity: Complexity.easy, project: "Health", tags: ["health", "exercise"], status: TaskStatus.completed, completionRate: 1.0),
//   Task(orderIndex: 10, id: "10", title: "Book flight tickets", description: "Book tickets for the upcoming vacation", dueDate: DateTime.now(), category: Category(categoryID: "7", name: "Hobbies", color: 0xff009688),
//       duration: 0.5, priority: Priority.medium, complexity: Complexity.easy, project: "Travel", tags: ["travel", "vacation"], status: TaskStatus.inreview, completionRate: 0.75),
];


  
final List<Category> categoryData = [
//   Category(categoryType: "1", name: "Personal", color: 0xfff44336),
//   Category(categoryID: "2", name: "Health", color: 0xff4caf50),
//   Category(categoryID: "3", name: "Social life", color: 0xffff9800),
//   Category(categoryID: "4", name: "Career", color: 0xff2196f3),
//   Category(categoryID: "5", name: "Spirituality", color: 0xff3f51b5),
//   Category(categoryID: "6", name: "Finance", color: 0xff9c27b0),
//   Category(categoryID: "7", name: "Hobbies", color: 0xff009688),
];

