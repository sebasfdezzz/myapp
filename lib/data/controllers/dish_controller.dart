import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/dish.dart';
import '../models/menu.dart';

class DishController {
    static Future<bool> createDish(Dish dish) async {
        try {
            http.Response response = await DishesApi.createDish(dish);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('DishController', 'Dish created successfully');
                return true;
            } else {
                await traceError('DishController', 'Failed to create dish: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('DishController', 'Error creating dish: $error');
            return false;
        }
    }

    static Future<Dish?> getDish(String dishId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await DishesApi.getDish(clientId, dishId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Dish? dish = Dish.fromJson(json);
                
                if (dish != null) {
                    await traceInfo('DishController', 'Retrieved dish $dishId');
                } else {
                    await traceError('DishController', 'Failed to parse dish $dishId');
                }
                return dish;
            } else {
                await traceError('DishController', 'Failed to get dish: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('DishController', 'Error getting dish: $error');
            return null;
        }
    }

    static Future<List<Dish>> getDishesByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await DishesApi.getDishesByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<Dish> dishes = jsonList
                    .map((json) => Dish.fromJson(json))
                    .where((dish) => dish != null)
                    .cast<Dish>()
                    .toList();
                
                await traceInfo('DishController', 'Retrieved ${dishes.length} dishes');
                return dishes;
            } else {
                await traceError('DishController', 'Failed to get dishes: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('DishController', 'Error getting dishes: $error');
            return [];
        }
    }

    static Future<bool> updateDish(Dish dish) async {
        try {
            http.Response response = await DishesApi.updateDish(dish);
            
            if (response.statusCode == 200) {
                await traceInfo('DishController', 'Dish updated successfully');
                return true;
            } else {
                await traceError('DishController', 'Failed to update dish: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('DishController', 'Error updating dish: $error');
            return false;
        }
    }

    static Future<bool> patchDish(String dishId, Map<String, dynamic> updates) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await DishesApi.patchDish(clientId, dishId, updates);
            
            if (response.statusCode == 200) {
                await traceInfo('DishController', 'Dish patched successfully');
                return true;
            } else {
                await traceError('DishController', 'Failed to patch dish: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('DishController', 'Error patching dish: $error');
            return false;
        }
    }

    static Future<bool> loadDishesToMenu() async {
        try {
            List<Dish> dishes = await getDishesByClient();
            
            // Group dishes by category
            Map<String, List<Dish>> groupedDishes = {};
            for (Dish dish in dishes) {
                if (!groupedDishes.containsKey(dish.category)) {
                    groupedDishes[dish.category] = [];
                }
                groupedDishes[dish.category]!.add(dish);
            }

            // Create categories and update global menu
            List<Category> categories = groupedDishes.entries.map((entry) {
                return Category(name: entry.key, dishes: entry.value);
            }).toList();

            GlobalData.menu = Menu(categories: categories);
            await traceInfo('DishController', 'Loaded ${dishes.length} dishes into menu with ${categories.length} categories');
            return true;
        } catch (error) {
            await traceError('DishController', 'Error loading dishes to menu: $error');
            return false;
        }
    }

    static Future<List<String>> getAllDishIds() async {
        try {
            List<Dish> dishes = await getDishesByClient();
            return dishes.map((dish) => dish.dishId).toList();
        } catch (error) {
            await traceError('DishController', 'Error getting dish IDs: $error');
            return [];
        }
    }
}
