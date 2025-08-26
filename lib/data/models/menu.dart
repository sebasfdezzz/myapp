import 'package:myapp/models/dish.dart';

class Menu {
  final List<Category> categories;

  Menu({required this.categories});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      categories: (json['categories'] as List)
          .map((c) => Category.fromJson(c))
          .toList(),
    );
  }

  static Menu? fromJson(Map<String, dynamic> json) {
    try {
       return Menu(
        categories: (json['categories'] as List)
            .map((c) => Category.fromJson(c))
            .toList(),
      );
    } catch (error) {
      traceError('default', 'Error parsing Menu from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'categories': categories.map((c) => c.toJson()).toList(),
    };
  }
}

class Category {
  final String name;
  final List<Dish> dishes;

  Category({
    required this.name,
    required this.dishes,
  });
    
  static Category? fromJson(Map<String, dynamic> json) {
    try {
       return Category(
        name: json['name'],
        dishes: (json['dishes'] as List)
            .map((p) => Dish.fromJson(p))
            .toList(),
      );
    } catch (error) {
      traceError('default', 'Error parsing Category from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dishes': dishes.map((p) => p.toJson()).toList(),
    };
  }
}