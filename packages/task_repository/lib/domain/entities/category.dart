import 'package:task_repository/domain/value_types.dart';

///Category Entity
class Category {
  CategoryType categoryType;
  String name;
  int color;
  String icon;

  Category({ 
      required this.categoryType,
      required this.name,
      required this.color,
      required this.icon,
  });

  static final empty = Category(
    categoryType: CategoryType.environment,
    name: '',
    color: 0,
    icon: '',
  );

  Category copyWith({
    CategoryType? categoryType,
    String? name,
    int? color,
    String? icon,
  }) {
    return Category(
      categoryType: categoryType ?? this.categoryType,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

}