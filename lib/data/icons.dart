import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_repository/domain/category_presets.dart';

///Give the exact label for a category name to get the representative IconData
final categoryNameToIconData = {
    CategoryPresets.body.name : FontAwesomeIcons.personRunning,
    CategoryPresets.mindAndSpirit.name : FontAwesomeIcons.brain,
    CategoryPresets.finance.name : FontAwesomeIcons.moneyBillWave,
    CategoryPresets.professional.name : FontAwesomeIcons.wrench,
    CategoryPresets.social.name : FontAwesomeIcons.peopleGroup,
    CategoryPresets.environment.name : FontAwesomeIcons.houseFlag,
    CategoryPresets.fun.name : FontAwesomeIcons.paintbrush,
  };