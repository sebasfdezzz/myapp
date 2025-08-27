import '../entities/dish.dart';
import '../../logs.dart';

class Menu {
  final List<Category> categories;

  Menu({required this.categories});

  static Menu? fromJson(Map<String, dynamic> json) {
    try {
       return Menu(
        categories: (json['categories'] as List)
            .map((c) => Category.fromJson(c)!)
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
            .map((p) => Dish.fromJson(p)!)
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

  // Helper methods for managing dishes in a category
  Category addDish(Dish dish) {
    return Category(name: name, dishes: [...dishes, dish]);
  }

  Category removeDish(String dishId) {
    return Category(name: name, dishes: dishes.where((dish) => dish.dishId != dishId).toList());
  }

  Category updateDish(Dish updatedDish) {
    return Category(name: name, dishes: dishes.map((dish) => 
      dish.dishId == updatedDish.dishId ? updatedDish : dish
    ).toList());
  }
}

// Additional menu helper methods
extension MenuHelpers on Menu {
  // Search dishes by name, description, or ingredients
  List<Dish> searchDishes(String query) {
    String lowerQuery = query.toLowerCase();
    List<Dish> results = [];
    
    for (var category in categories) {
      for (var dish in category.dishes) {
        if (dish.name.toLowerCase().contains(lowerQuery) ||
            dish.description.toLowerCase().contains(lowerQuery) ||
            dish.ingredients.any((ingredient) => 
              ingredient.ingredientName.toLowerCase().contains(lowerQuery))) {
          results.add(dish);
        }
      }
    }
    
    return results;
  }

  // Get dishes by category
  List<Dish> getDishesByCategory(String categoryName) {
    try {
      Category category = categories.firstWhere(
        (cat) => cat.name.toLowerCase() == categoryName.toLowerCase(),
      );
      return category.dishes;
    } catch (e) {
      return [];
    }
  }

  // Get all dishes
  List<Dish> getAllDishes() {
    List<Dish> allDishes = [];
    for (var category in categories) {
      allDishes.addAll(category.dishes);
    }
    return allDishes;
  }

  // Get dishes by price range
  List<Dish> getDishesByPriceRange(int minPrice, int maxPrice) {
    List<Dish> results = [];
    for (var category in categories) {
      results.addAll(category.dishes.where((dish) => 
        dish.price >= minPrice && dish.price <= maxPrice
      ));
    }
    return results;
  }

  // Get available dishes
  List<Dish> getAvailableDishes() {
    List<Dish> results = [];
    for (var category in categories) {
      results.addAll(category.dishes.where((dish) => dish.status == 'AVAILABLE'));
    }
    return results;
  }

  // Helper methods for managing categories
  Menu addCategory(Category category) {
    return Menu(categories: [...categories, category]);
  }

  Menu removeCategory(String categoryName) {
    return Menu(categories: categories.where((cat) => cat.name != categoryName).toList());
  }

  Menu updateCategory(Category updatedCategory) {
    return Menu(categories: categories.map((cat) => 
      cat.name == updatedCategory.name ? updatedCategory : cat
    ).toList());
  }
}