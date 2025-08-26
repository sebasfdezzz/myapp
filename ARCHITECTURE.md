# Flutter App Architecture Documentation

This document explains the organized structure for handling API interactions, entities, models, and controllers in the Flutter application.

## Architecture Overview

The application follows a clean architecture pattern with the following layers:

- **Entities**: Pure data models that represent database objects
- **Models**: Application-specific models that organize data for UI consumption
- **API Layer**: Handles all HTTP communications with the backend
- **Controllers**: Static business logic that coordinates between API and UI
- **Global Data**: Centralized state management

## Directory Structure

```
lib/
├── api.dart                    # Base API classes and all endpoint handlers
├── config.dart                 # Configuration constants
├── logs.dart                   # Logging utilities
├── data/
│   ├── global_data.dart        # Global application state
│   ├── entities/               # Database entity models
│   │   ├── account.dart
│   │   ├── client.dart
│   │   ├── dish.dart
│   │   ├── opinion.dart
│   │   ├── pairing.dart
│   │   ├── payment.dart
│   │   ├── wine.dart
│   │   └── wine_sale.dart
│   ├── models/                 # Application models
│   │   ├── cellar.dart         # Organizes wines collection
│   │   └── menu.dart           # Organizes dishes by category
│   └── controllers/            # Business logic controllers
│       ├── app_controller.dart        # Main app initialization
│       ├── account_controller.dart
│       ├── client_controller.dart
│       ├── dish_controller.dart
│       ├── opinion_controller.dart
│       ├── pairing_controller.dart
│       ├── payment_controller.dart
│       ├── wine_controller.dart
│       └── wine_sale_controller.dart
```

## Key Components

### 1. Entities

All entities follow the same pattern:
- Factory constructor for creating new instances
- `fromJson` static method for parsing API responses
- `toJson` method for API requests
- Proper handling of pk/sk and ID extraction

**Example Usage:**
```dart
// Creating a new dish
final dish = Dish(
  clientId: "1234",
  name: "Paella",
  description: "Delicious seafood paella",
  category: "main_dish",
  price: 2500,
  ingredients: [
    Ingredient(ingredientName: "Rice", presenceWeight: 5),
    Ingredient(ingredientName: "Seafood", presenceWeight: 3),
  ]
);

// Parsing from API response
final dish = Dish.fromJson(apiResponse);
```

### 2. API Layer

All API classes extend the base `Api` class and provide specific endpoints:

**Available API Classes:**
- `AccountsApi` - Account management
- `ClientsApi` - Client operations
- `DishesApi` - Dish CRUD operations
- `PairingsApi` - Wine pairing management
- `PaymentsApi` - Payment processing
- `WinesApi` - Wine inventory management
- `WineSalesApi` - Sales tracking
- `OpinionsApi` - Customer reviews

**Example Usage:**
```dart
// Get all dishes for a client
http.Response response = await DishesApi.getDishesByClient(clientId);

// Create a new wine
http.Response response = await WinesApi.createWine(wine);

// Update payment status
http.Response response = await PaymentsApi.patchPayment(paymentId, {'status': 'SUCCESSFUL'});
```

### 3. Controllers

Controllers provide static methods for business logic and automatically handle:
- Error logging
- Global state updates
- Data transformation
- Common operations

**Example Usage:**
```dart
// Initialize the entire app
await AppController.initializeAppByCognito(cognitoId);

// Create wine pairings for all dishes
bool success = await PairingController.createAllPairings();

// Load client's dishes into the global menu
bool success = await DishController.loadDishesToMenu();

// Record a wine sale
bool success = await WineSaleController.recordWineSale(wineId, amount);
```

### 4. Models

#### Menu Model
Organizes dishes by categories with helper methods:

```dart
// Search dishes
List<Dish> results = GlobalData.menu.searchDishes("paella");

// Get dishes by category
List<Dish> mains = GlobalData.menu.getDishesByCategory("main_dish");

// Get all available dishes
List<Dish> available = GlobalData.menu.getAvailableDishes();
```

#### Cellar Model
Organizes wine collection with filtering capabilities:

```dart
// Get wines by type
List<Wine> redWines = GlobalData.cellar.getWinesByType("Red");

// Search wines
List<Wine> results = GlobalData.cellar.searchWines("rioja");

// Get wines in stock
List<Wine> inStock = GlobalData.cellar.getWinesInStock();
```

### 5. Global Data

Centralized state accessible throughout the app:

```dart
// Access current client
String clientId = GlobalData.client.clientId;
String clientName = GlobalData.client.clientName;

// Access menu data
List<Category> categories = GlobalData.menu.categories;
List<Dish> allDishes = GlobalData.menu.getAllDishes();

// Access wine cellar
List<Wine> wines = GlobalData.cellar.wines;
List<Wine> inStock = GlobalData.cellar.getWinesInStock();
```

## Usage Patterns

### App Initialization

```dart
// In your main app startup
void initializeApp() async {
  // Option 1: Initialize with cognito ID (recommended)
  bool success = await AppController.initializeAppByCognito(cognitoId);
  
  // Option 2: Initialize with client ID
  bool success = await AppController.initializeApp(clientId);
  
  if (success) {
    // App is ready, global data is populated
    print('App initialized successfully');
    print('Menu has ${GlobalData.menu.categories.length} categories');
    print('Cellar has ${GlobalData.cellar.wines.length} wines');
  }
}
```

### Creating Wine Pairings

```dart
// Create pairing for a single dish
bool success = await PairingController.createSinglePairing(dishId);

// Create pairings for multiple dishes
List<String> dishIds = ["D001", "D002", "D003"];
bool success = await PairingController.createMultiplePairings(dishIds);

// Create pairings for ALL dishes (triggers AI processing)
bool success = await PairingController.createAllPairings();
```

### Recording Customer Opinion

```dart
final opinion = Opinion(
  clientId: GlobalData.client.clientId,
  dishId: "D001",
  wineId: "W200",
  comment: "Perfect pairing!",
  dishDescription: "Seafood paella with saffron",
  wineDescription: "Crisp white wine with citrus notes",
  rate: 5,
);

bool success = await OpinionController.createOpinion(opinion);
```

### Processing Wine Sales

```dart
// Record a wine sale
bool success = await WineSaleController.recordWineSale("W200", 2);

// Get sales analytics
Map<String, int> salesByWine = await WineSaleController.getSalesByWine();
int totalSales = await WineSaleController.getTotalSalesAmount();
```

### Refreshing Data

```dart
// Refresh all data from backend
bool success = await AppController.refreshAllData();

// Refresh specific data
bool success = await DishController.loadDishesToMenu();
bool success = await WineController.loadWinesToCellar();
```

## Error Handling

All controllers automatically log errors using the `traceError`, `traceInfo`, and `traceWarning` functions. Check the logs for debugging information.

## Database Key Structure

The application handles DynamoDB key structures automatically:

- **PK (Partition Key)**: Usually `CLIENT-{clientId}` or `ACCOUNT-{accountId}`
- **SK (Sort Key)**: Entity-specific like `DISH-{dishId}`, `WINE-{wineId}`, etc.
- **ID Extraction**: Controllers automatically extract IDs from pk/sk when parsing JSON

Example:
- PK: `CLIENT-1234`, SK: `DISH-D100` → `clientId: "1234"`, `dishId: "D100"`
- PK: `CLIENT-1234`, SK: `WINE-W200-WINESALE-WS500` → `clientId: "1234"`, `wineId: "W200"`, `wineSaleId: "WS500"`

## Next Steps

1. Integrate controllers into your UI components
2. Add authentication flow to get cognito ID
3. Implement error handling in UI
4. Add data refresh triggers based on user actions
5. Consider adding local caching for offline support

The architecture is designed to be scalable and maintainable, with clear separation of concerns and easy testing capabilities.
