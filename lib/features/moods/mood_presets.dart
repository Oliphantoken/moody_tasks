import 'package:flutter/material.dart';
import 'package:task_repository/domain/value_types.dart';

class MoodPresets {
  
// static final content = {
//   'type': Mood.content,
//   'name': Mood.content.displayName,
//   'color': Colors.pink[100],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.face_2_rounded // match your asset naming if you use it
// };

// static final excited = {
//   'type': Mood.excited,
//   'name': Mood.excited.displayName,
//   'color': Colors.amber[200],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.rocket_launch // match your asset naming if you use it
// };

// static final sad = {
//   'type': Mood.sad,
//   'name': Mood.sad.displayName,
//   'color': Colors.blueGrey[200],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.heart_broken // match your asset naming if you use it
// };

// static final upset = {
//   'type': Mood.upset,
//   'name': Mood.upset.displayName,
//   'color': Colors.indigo[300],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.thunderstorm // match your asset naming if you use it
// };

// static final determined = {
//   'type': Mood.determined,
//   'name': Mood.determined.displayName,
//   'color': Colors.green[300],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.accessibility // match your asset naming if you use it
// };

// static final panicking = {
//   'type': Mood.panicking,
//   'name': Mood.panicking.displayName,
//   'color': Colors.red[300],//0xFFFFF3C4, // soft yellow
//   'icon': Icons.fireplace_outlined // match your asset naming if you use it
// };

// static final restless = {
//   'type': Mood.restless,
//   'name': Mood.restless.displayName,
//   'color': Colors.yellow ,//0xFFFFF3C4, // soft yellow
//   'icon': Icons.keyboard_double_arrow_right_sharp // match your asset naming if you use it
// };

// static final drained = {
//   'type': Mood.drained,
//   'name': Mood.drained.displayName,
//   'color': Colors.brown,//0xFFFFF3C4, // soft yellow
//   'icon': Icons.battery_1_bar_sharp // match your asset naming if you use it
// };

  static final getMoodColor = {
    Mood.content: Colors.pink[100],
    Mood.excited: Colors.amber[200],
    Mood.sad: Colors.blueGrey[200],
    Mood.upset: Colors.indigo[300],
    Mood.determined: Colors.green[300],
    Mood.panicking: Colors.red[300],
    Mood.restless: Colors.yellow,
    Mood.drained: Colors.brown,
  };

  static final Map<Mood, IconData> getMoodIcon = {
    Mood.content: Icons.face_2_rounded,
    Mood.excited: Icons.rocket_launch,
    Mood.sad: Icons.heart_broken,
    Mood.upset: Icons.thunderstorm,
    Mood.determined: Icons.accessibility,
    Mood.panicking: Icons.fireplace_outlined,
    Mood.restless: Icons.keyboard_double_arrow_right_sharp,
    Mood.drained: Icons.battery_1_bar_sharp
  };

}