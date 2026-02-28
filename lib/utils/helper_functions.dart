
import 'package:flutter/material.dart';
import 'package:task_repository/domain/value_types.dart';
  import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_repository/domain/category_presets.dart';


class Helper {
  static Color getColorBasedOnTaskStatus(TaskStatus status) {
    return status == TaskStatus.completed? Colors.green
        : status == TaskStatus.inreview? Colors.cyan
        : status == TaskStatus.inprogress? Colors.orange
        : status == TaskStatus.todo? Colors.black
        : status == TaskStatus.backlog? Colors.grey
        : status == TaskStatus.blocked? Colors.red
        : Colors.grey;
  }

  static Color getColorBasedOnDueDate(DateTime dueDate) {
    final now = DateTime.now();
    if (dueDate.isAtSameMomentAs(now) || dueDate.isBefore(now)) {
      return Colors.red; // Due or Overdue
    } else if (dueDate.isAfter(now) && dueDate.isBefore(now.add(Duration(days: 3)))) {
      return Colors.orange; // Due soon
    } else {
      return Colors.green; // Not urgent
    }
  }

  static Color getColorBasedOnDueBy(DueBy due) {
    return due == DueBy.today? Colors.amber
    : due == DueBy.thisWeek? Colors.yellow
    : due == DueBy.thisMonth? Colors.green
    : due == DueBy.overdue? Colors.red
    : Colors.grey;
  }

  static Color getColorBasedOnPriority(Priority priority){
    return priority == Priority.low? Colors.green
      : priority == Priority.medium? Colors.orange
      : priority == Priority.high? Colors.red
      : Colors.grey;
  }

  static Color getColorBasedOnComplexity(Complexity complexity){
    return complexity == Complexity.easy? Colors.green
      : complexity == Complexity.moderate? Colors.orange
      : complexity == Complexity.complex? Colors.red
      : Colors.grey;
  }


///Give the exact label for a category name to get the representative IconData
static final getCategoryNameToIconData = {
    CategoryPresets.body.name : FontAwesomeIcons.personRunning,
    CategoryPresets.mindAndSpirit.name : FontAwesomeIcons.brain,
    CategoryPresets.finance.name : FontAwesomeIcons.moneyBillWave,
    CategoryPresets.professional.name : FontAwesomeIcons.wrench,
    CategoryPresets.social.name : FontAwesomeIcons.peopleGroup,
    CategoryPresets.environment.name : FontAwesomeIcons.houseFlag,
    CategoryPresets.fun.name : FontAwesomeIcons.paintbrush,
};



}