import '../global_data.dart';
import '../../logs.dart';
import 'client_controller.dart';
import 'dish_controller.dart';
import 'wine_controller.dart';
import '../entities/client.dart';
import '../models/menu.dart';
import '../models/cellar.dart';

/// AppController manages the initialization and global state of the application
/// Use this to load all necessary data when the app starts
class AppController {
    
    /// Initialize the app with a client ID
    /// This loads the client data and populates menu and cellar
    static Future<bool> initializeApp(String clientId) async {
        try {
            await traceInfo('AppController', 'Starting app initialization for client $clientId');
            
            // Load client data
            bool clientLoaded = await ClientController.loadClientToGlobal(clientId);
            if (!clientLoaded) {
                await traceError('AppController', 'Failed to load client data');
                return false;
            }
            
            // Load dishes to menu
            bool dishesLoaded = await DishController.loadDishesToMenu();
            if (!dishesLoaded) {
                await traceWarning('AppController', 'Failed to load dishes to menu');
            }
            
            // Load wines to cellar
            bool winesLoaded = await WineController.loadWinesToCellar();
            if (!winesLoaded) {
                await traceWarning('AppController', 'Failed to load wines to cellar');
            }
            
            await traceInfo('AppController', 'App initialization completed successfully');
            return true;
        } catch (error) {
            await traceError('AppController', 'Error during app initialization: $error');
            return false;
        }
    }
    
    /// Initialize the app with a Cognito ID
    /// This loads the client data by Cognito ID and populates menu and cellar
    static Future<bool> initializeAppByCognito(String cognitoId) async {
        try {
            await traceInfo('AppController', 'Starting app initialization for cognito ID $cognitoId');
            
            // Load client data by cognito ID
            bool clientLoaded = await ClientController.loadClientByCognitoToGlobal(cognitoId);
            if (!clientLoaded) {
                await traceError('AppController', 'Failed to load client data by cognito ID');
                return false;
            }
            
            // Load dishes to menu
            bool dishesLoaded = await DishController.loadDishesToMenu();
            if (!dishesLoaded) {
                await traceWarning('AppController', 'Failed to load dishes to menu');
            }
            
            // Load wines to cellar
            bool winesLoaded = await WineController.loadWinesToCellar();
            if (!winesLoaded) {
                await traceWarning('AppController', 'Failed to load wines to cellar');
            }
            
            await traceInfo('AppController', 'App initialization completed successfully');
            return true;
        } catch (error) {
            await traceError('AppController', 'Error during app initialization: $error');
            return false;
        }
    }
    
    /// Refresh all data from the backend
    static Future<bool> refreshAllData() async {
        try {
            await traceInfo('AppController', 'Refreshing all data');
            
            if (GlobalData.client.clientId.isEmpty) {
                await traceError('AppController', 'No client loaded, cannot refresh data');
                return false;
            }
            
            // Refresh client data
            bool clientRefreshed = await ClientController.loadClientToGlobal(GlobalData.client.clientId);
            
            // Refresh dishes
            bool dishesRefreshed = await DishController.loadDishesToMenu();
            
            // Refresh wines
            bool winesRefreshed = await WineController.loadWinesToCellar();
            
            bool success = clientRefreshed && dishesRefreshed && winesRefreshed;
            
            if (success) {
                await traceInfo('AppController', 'All data refreshed successfully');
            } else {
                await traceWarning('AppController', 'Some data refresh operations failed');
            }
            
            return success;
        } catch (error) {
            await traceError('AppController', 'Error refreshing data: $error');
            return false;
        }
    }
    
    /// Clear all global data
    static void clearAllData() {
        GlobalData.client = Client(
            clientName: '',
            cognitoId: '',
            address: '',
            city: '',
            country: '',
            latitude: '',
            longitude: '',
            neighborhood: '',
            zipCode: '',
            planType: '',
        );
        GlobalData.cellar = Cellar();
        GlobalData.menu = Menu(categories: []);
        traceInfo('AppController', 'All global data cleared');
    }
    
    /// Check if the app is properly initialized
    static bool isAppInitialized() {
        return GlobalData.client.clientId.isNotEmpty;
    }
    
    /// Get current app status for debugging
    static Map<String, dynamic> getAppStatus() {
        return {
            'client_loaded': GlobalData.client.clientId.isNotEmpty,
            'client_id': GlobalData.client.clientId,
            'client_name': GlobalData.client.clientName,
            'menu_categories': GlobalData.menu.categories.length,
            'total_dishes': GlobalData.menu.getAllDishes().length,
            'cellar_wines': GlobalData.cellar.wines.length,
            'wines_in_stock': GlobalData.cellar.getWinesInStock().length,
        };
    }
}
