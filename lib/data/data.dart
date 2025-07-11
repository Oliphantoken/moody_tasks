import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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