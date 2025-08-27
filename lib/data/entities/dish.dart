import 'package:uuid/uuid.dart';

import '../../logs.dart';

var example_json = {
 "pk": "CLIENT-1234",
 "sk": "DISH-D100",
 "category": "main_dish",
 "description": "Paella deliciosa",
 "name": "Paella Valenciana",
 "entity_type": "Dish",
 "image_url": "link",
 "ingredients": [
  {
   "ingredient_name": "Rice",
   "presence_weight": 5
  },
  {
   "ingredient_name": "Seafood",
   "presence_weight": 3
  },
  {
   "ingredient_name": "Saffron",
   "presence_weight": 2
  }
 ],
 "price": 2500,
 "status": "AVAILABLE"
};

class Ingredient {
    String ingredientName;
    int presenceWeight;

    Ingredient({
        required this.ingredientName,
        required this.presenceWeight,
    });

    static Ingredient? fromJson(Map<String, dynamic> json) {
        try {
            return Ingredient(
                ingredientName: json['ingredient_name'],
                presenceWeight: json['presence_weight'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Ingredient from JSON: $error');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'ingredient_name': ingredientName,
            'presence_weight': presenceWeight,
        };
    }
}

class Dish {
    String pk;
    String sk;
    String clientId;
    String dishId;
    String category;
    String description;
    String name;
    String entityType;
    String imageUrl;
    List<Ingredient> ingredients;
    int price;
    String status;

    Dish._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.dishId,
        required this.category,
        required this.description,
        required this.name,
        required this.entityType,
        required this.imageUrl,
        required this.ingredients,
        required this.price,
        required this.status,
    });

    factory Dish({
        required String clientId,
        required String name,
        required String description,
        required String category,
        required int price,
        required List<Ingredient> ingredients,
        String imageUrl = '',
        String status = 'AVAILABLE',
    }) {
        final dishId = _generateId();
        return Dish._internal(
            pk: 'CLIENT-$clientId',
            sk: 'DISH-$dishId',
            clientId: clientId,
            dishId: dishId,
            category: category,
            description: description,
            name: name,
            entityType: 'Dish',
            imageUrl: imageUrl,
            ingredients: ingredients,
            price: price,
            status: status,
        );
    }

    static String _generateId() {
        return Uuid().v4();
    }

    static Dish? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            String sk = json['sk'];
            List<String> pkParts = pk.split("-");
            List<String> skParts = sk.split("-");
            
            List<Ingredient> ingredients = [];
            if (json['ingredients'] != null) {
                ingredients = (json['ingredients'] as List)
                    .map((i) => Ingredient.fromJson(i))
                    .where((i) => i != null)
                    .cast<Ingredient>()
                    .toList();
            }
            
            return Dish._internal(
                pk: pk,
                sk: sk,
                clientId: pkParts[1],
                dishId: skParts[1],
                category: json['category'],
                description: json['description'],
                name: json['name'],
                entityType: json['entity_type'],
                imageUrl: json['image_url'] ?? '',
                ingredients: ingredients,
                price: json['price'],
                status: json['status'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Dish from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'category': category,
            'description': description,
            'name': name,
            'entity_type': entityType,
            'image_url': imageUrl,
            'ingredients': ingredients.map((i) => i.toJson()).toList(),
            'price': price,
            'status': status,
        };
    }
}