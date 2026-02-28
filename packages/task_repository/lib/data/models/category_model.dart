///DBs only understands maps, not objects.
///So we're converting between Category (object) and CategoryEntity (Map),
///to pass on data back and forth between application and database storage.
library;
import 'package:task_repository/domain/value_types.dart';
import '../../domain/entities/category.dart';

class CategoryModel {
  String categoryType;
  String name;
  int color;
  String icon;

  CategoryModel({ 
      required this.categoryType,
      required this.name,
      required this.color,
      required this.icon,
  });

  ///Convert from map to model
  static CategoryModel fromMap(Map<String, dynamic> map){
    return CategoryModel(
      categoryType: map['categoryType'] as String,
      name: map['name'] as String,
      color: map['color'] as int,
      icon: map['icon'] as String
    );
  }

  ///Convert from model to Map
  Map<String, Object> toMap(){
    return {
      'categoryType': categoryType,
      'name': name,
      'color': color,
      'icon': icon
    };
  }

  ///Convert from entity to a model
  static CategoryModel fromEntity(Category entity){
    return CategoryModel(
      categoryType : entity.categoryType.displayName,
      name : entity.name,
      color : entity.color,
      icon: entity.icon,
    );
  }

  ///Convert  thafrom model to entity
  Category toEntity(){
    return Category (
      categoryType : CategoryTypeExtension.fromString(categoryType),
      name : name,
      color : color,
      icon: icon,
    );
  }



}