import 'entities/category.dart';
import 'value_types.dart';

class CategoryPresets {
  
static final fun = Category(
    categoryType: CategoryType.fun,
    name: CategoryType.fun.displayName,
    color: 0xFFFF9D00,//0xFFFFF3C4, // soft yellow
    icon: 'paintbrush', // match your asset naming if you use it
  );

  static final body = Category(
    categoryType: CategoryType.body,
    name: CategoryType.body.displayName,
    color: 0xFF69eaff,//0xFFCDEFFF,
    icon: 'personRunning',
  );

  static final mindAndSpirit = Category(
    categoryType: CategoryType.mindAndSpirit,
    name: CategoryType.mindAndSpirit.displayName,
    color: 0xFFbe719a, //0xFFE3D7FF,
    icon: 'brain',
  );

  static final finance = Category(
    categoryType: CategoryType.finance,
    name: CategoryType.finance.displayName,
    color: 0xFF16ba00, //0xFFDFFFE0,
    icon: 'moneyBillWave',
  );

  static final professional = Category(
    categoryType: CategoryType.professional,
    name: CategoryType.professional.displayName,
    color: 0xFFFF9D00, //0xFFFFE1E1,
    icon: 'wrench',
  );

  static final social = Category(
    categoryType: CategoryType.social,
    name: CategoryType.social.displayName,
    color: 0xFF01bfd8, //0xFFD0F0FF,
    icon: 'peopleGroup',
  );

  static final environment = Category(
    categoryType: CategoryType.environment,
    name: CategoryType.environment.displayName,
    color: 0xFFe65d6b, //0xFF239799, //0xFFFBE4FF,
    icon: 'houseFlag',
  );

  static final all = <Category>[
    fun,
    body,
    mindAndSpirit,
    finance,
    professional,
    social,
    environment,
  ];

}