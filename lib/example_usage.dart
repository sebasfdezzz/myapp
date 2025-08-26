import 'package:flutter/material.dart';
import 'data/controllers/app_controller.dart';
import 'data/controllers/pairing_controller.dart';
import 'data/controllers/opinion_controller.dart';
import 'data/controllers/wine_sale_controller.dart';
import 'data/global_data.dart';
import 'data/entities/opinion.dart';
import 'data/entities/dish.dart';
import 'data/entities/wine.dart';

/// Example usage of the organized architecture
/// This shows how to use the controllers and models in a real Flutter app
class ExampleUsage {
  
  /// Example: Initialize the app when user logs in
  static Future<void> initializeAppExample(String cognitoId) async {
    try {
      // Initialize all app data
      bool success = await AppController.initializeAppByCognito(cognitoId);
      
      if (success) {
        print('✅ App initialized successfully!');
        print('Client: ${GlobalData.client.clientName}');
        print('Menu categories: ${GlobalData.menu.categories.length}');
        print('Wines in cellar: ${GlobalData.cellar.wines.length}');
        
        // App is ready for use
      } else {
        print('❌ App initialization failed');
        // Handle error - maybe show login screen again
      }
    } catch (error) {
      print('Error during initialization: $error');
    }
  }
  
  /// Example: Create wine pairings workflow
  static Future<void> createPairingsExample() async {
    try {
      // Get all dish IDs from current menu
      List<String> dishIds = GlobalData.menu.getAllDishes()
          .map((dish) => dish.dishId)
          .toList();
      
      if (dishIds.isEmpty) {
        print('No dishes available for pairing');
        return;
      }
      
      // Option 1: Create pairings for specific dishes
      List<String> selectedDishes = dishIds.take(3).toList();
      bool success = await PairingController.createMultiplePairings(selectedDishes);
      
      if (success) {
        print('✅ Pairings created for ${selectedDishes.length} dishes');
      }
      
      // Option 2: Create pairings for ALL dishes (AI processing)
      bool allSuccess = await PairingController.createAllPairings();
      
      if (allSuccess) {
        print('✅ All pairings created successfully');
        
        // Get the created pairings
        var pairings = await PairingController.getPairingsByClient();
        print('Total pairings: ${pairings.length}');
      }
      
    } catch (error) {
      print('Error creating pairings: $error');
    }
  }
  
  /// Example: Search and filter functionality
  static void searchAndFilterExample() {
    // Search dishes
    List<Dish> paellaResults = GlobalData.menu.searchDishes('paella');
    print('Found ${paellaResults.length} dishes matching "paella"');
    
    // Get dishes by category
    List<Dish> mainDishes = GlobalData.menu.getDishesByCategory('main_dish');
    print('Main dishes: ${mainDishes.length}');
    
    // Search wines
    List<Wine> riojaWines = GlobalData.cellar.searchWines('rioja');
    print('Found ${riojaWines.length} Rioja wines');
    
    // Get wines by type
    List<Wine> redWines = GlobalData.cellar.getWinesByType('Red');
    print('Red wines: ${redWines.length}');
    
    // Get wines in stock
    List<Wine> inStock = GlobalData.cellar.getWinesInStock();
    print('Wines in stock: ${inStock.length}');
  }
  
  /// Example: Customer opinion workflow
  static Future<void> recordOpinionExample() async {
    try {
      // Check if we have dishes and wines
      List<Dish> dishes = GlobalData.menu.getAllDishes();
      List<Wine> wines = GlobalData.cellar.wines;
      
      if (dishes.isEmpty || wines.isEmpty) {
        print('Need dishes and wines to record opinion');
        return;
      }
      
      // Create an opinion
      final opinion = Opinion(
        clientId: GlobalData.client.clientId,
        dishId: dishes.first.dishId,
        wineId: wines.first.wineId,
        comment: 'Excellent pairing! The wine complements the dish perfectly.',
        dishDescription: dishes.first.description,
        wineDescription: wines.first.description,
        rate: 5,
      );
      
      bool success = await OpinionController.createOpinion(opinion);
      
      if (success) {
        print('✅ Opinion recorded successfully');
        
        // Get average rating for this wine
        double avgRating = await OpinionController.getAverageRatingForWine(wines.first.wineId);
        print('Average rating for ${wines.first.name}: $avgRating/5');
      }
      
    } catch (error) {
      print('Error recording opinion: $error');
    }
  }
  
  /// Example: Wine sales workflow
  static Future<void> wineSalesExample() async {
    try {
      List<Wine> inStockWines = GlobalData.cellar.getWinesInStock();
      
      if (inStockWines.isEmpty) {
        print('No wines in stock');
        return;
      }
      
      Wine wineToSell = inStockWines.first;
      int amountToSell = 2;
      
      // Record the sale
      bool saleSuccess = await WineSaleController.recordWineSale(
        wineToSell.wineId, 
        amountToSell
      );
      
      if (saleSuccess) {
        print('✅ Wine sale recorded: ${wineToSell.name} x$amountToSell');
        
        // Get sales analytics
        Map<String, int> salesByWine = await WineSaleController.getSalesByWine();
        int totalSales = await WineSaleController.getTotalSalesAmount();
        
        print('Total sales amount: $totalSales');
        print('Sales by wine: ${salesByWine.length} different wines sold');
      }
      
    } catch (error) {
      print('Error processing wine sale: $error');
    }
  }
  
  /// Example: Data refresh workflow
  static Future<void> refreshDataExample() async {
    try {
      print('🔄 Refreshing all data...');
      
      bool success = await AppController.refreshAllData();
      
      if (success) {
        print('✅ All data refreshed successfully');
        
        // Show updated status
        Map<String, dynamic> status = AppController.getAppStatus();
        print('App Status: $status');
      } else {
        print('⚠️ Some data refresh operations failed');
      }
      
    } catch (error) {
      print('Error refreshing data: $error');
    }
  }
  
  /// Example: Building a Flutter widget that uses the controllers
  static Widget buildDishListWidget() {
    return FutureBuilder<bool>(
      future: AppController.refreshAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError || !snapshot.data!) {
          return Text('Error loading dishes');
        }
        
        List<Dish> dishes = GlobalData.menu.getAllDishes();
        
        return ListView.builder(
          itemCount: dishes.length,
          itemBuilder: (context, index) {
            Dish dish = dishes[index];
            return ListTile(
              title: Text(dish.name),
              subtitle: Text(dish.description),
              trailing: Text('\$${(dish.price / 100).toStringAsFixed(2)}'),
              onTap: () async {
                // Create pairing for this dish
                bool success = await PairingController.createSinglePairing(dish.dishId);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Pairing created for ${dish.name}')),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
  
  /// Example: Complete app initialization flow
  static Future<void> completeAppFlowExample(String cognitoId) async {
    try {
      // Step 1: Initialize app
      print('🚀 Starting app initialization...');
      await initializeAppExample(cognitoId);
      
      // Step 2: Check if app is ready
      if (!AppController.isAppInitialized()) {
        print('❌ App not properly initialized');
        return;
      }
      
      // Step 3: Create pairings for the menu
      print('🍷 Creating wine pairings...');
      await createPairingsExample();
      
      // Step 4: Demonstrate search functionality
      print('🔍 Testing search functionality...');
      searchAndFilterExample();
      
      // Step 5: Record a customer opinion
      print('📝 Recording customer opinion...');
      await recordOpinionExample();
      
      // Step 6: Process wine sales
      print('💰 Processing wine sales...');
      await wineSalesExample();
      
      // Step 7: Show final status
      print('📊 Final app status:');
      Map<String, dynamic> status = AppController.getAppStatus();
      status.forEach((key, value) {
        print('  $key: $value');
      });
      
      print('✅ Complete app flow example finished successfully!');
      
    } catch (error) {
      print('❌ Error in complete app flow: $error');
    }
  }
}
