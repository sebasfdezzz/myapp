import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/wine.dart';
import '../models/cellar.dart';

class WineController {
    static Future<bool> createWine(Wine wine) async {
        try {
            http.Response response = await WinesApi.createWine(wine);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('WineController', 'Wine created successfully');
                return true;
            } else {
                await traceError('WineController', 'Failed to create wine: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('WineController', 'Error creating wine: $error');
            return false;
        }
    }

    static Future<Wine?> getWine(String wineId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await WinesApi.getWine(clientId, wineId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Wine? wine = Wine.fromJson(json);
                
                if (wine != null) {
                    await traceInfo('WineController', 'Retrieved wine $wineId');
                } else {
                    await traceError('WineController', 'Failed to parse wine $wineId');
                }
                return wine;
            } else {
                await traceError('WineController', 'Failed to get wine: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('WineController', 'Error getting wine: $error');
            return null;
        }
    }

    static Future<List<Wine>> getWinesByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await WinesApi.getWinesByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<Wine> wines = jsonList
                    .map((json) => Wine.fromJson(json))
                    .where((wine) => wine != null)
                    .cast<Wine>()
                    .toList();
                
                await traceInfo('WineController', 'Retrieved ${wines.length} wines');
                return wines;
            } else {
                await traceError('WineController', 'Failed to get wines: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('WineController', 'Error getting wines: $error');
            return [];
        }
    }

    static Future<bool> updateWine(Wine wine) async {
        try {
            http.Response response = await WinesApi.updateWine(wine);
            
            if (response.statusCode == 200) {
                await traceInfo('WineController', 'Wine updated successfully');
                return true;
            } else {
                await traceError('WineController', 'Failed to update wine: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('WineController', 'Error updating wine: $error');
            return false;
        }
    }

    static Future<bool> patchWine(String wineId, Map<String, dynamic> updates) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await WinesApi.patchWine(clientId, wineId, updates);
            
            if (response.statusCode == 200) {
                await traceInfo('WineController', 'Wine patched successfully');
                return true;
            } else {
                await traceError('WineController', 'Failed to patch wine: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('WineController', 'Error patching wine: $error');
            return false;
        }
    }

    static Future<bool> loadWinesToCellar() async {
        try {
            List<Wine> wines = await getWinesByClient();
            GlobalData.cellar = Cellar(wines: wines);
            await traceInfo('WineController', 'Loaded ${wines.length} wines into cellar');
            return true;
        } catch (error) {
            await traceError('WineController', 'Error loading wines to cellar: $error');
            return false;
        }
    }

    static Future<List<Wine>> getWinesInStock() async {
        try {
            List<Wine> allWines = await getWinesByClient();
            List<Wine> inStockWines = allWines.where((wine) => 
                wine.status == 'IN_STOCK' && wine.availableItems > 0
            ).toList();
            
            await traceInfo('WineController', 'Retrieved ${inStockWines.length} wines in stock');
            return inStockWines;
        } catch (error) {
            await traceError('WineController', 'Error getting wines in stock: $error');
            return [];
        }
    }

    static Future<List<Wine>> getWinesByType(String type) async {
        try {
            List<Wine> allWines = await getWinesByClient();
            List<Wine> typeWines = allWines.where((wine) => 
                wine.type.toLowerCase() == type.toLowerCase()
            ).toList();
            
            await traceInfo('WineController', 'Retrieved ${typeWines.length} ${type} wines');
            return typeWines;
        } catch (error) {
            await traceError('WineController', 'Error getting wines by type: $error');
            return [];
        }
    }

    static Future<List<Wine>> getWinesByRegion(String region) async {
        try {
            List<Wine> allWines = await getWinesByClient();
            List<Wine> regionWines = allWines.where((wine) => 
                wine.region.toLowerCase().contains(region.toLowerCase())
            ).toList();
            
            await traceInfo('WineController', 'Retrieved ${regionWines.length} wines from $region');
            return regionWines;
        } catch (error) {
            await traceError('WineController', 'Error getting wines by region: $error');
            return [];
        }
    }

    static Future<bool> updateWineStock(String wineId, int newStock) async {
        return await patchWine(wineId, {'available_items': newStock});
    }

    static Future<bool> decreaseWineStock(String wineId, int amount) async {
        try {
            Wine? wine = await getWine(wineId);
            if (wine != null && wine.availableItems >= amount) {
                int newStock = wine.availableItems - amount;
                return await updateWineStock(wineId, newStock);
            }
            return false;
        } catch (error) {
            await traceError('WineController', 'Error decreasing wine stock: $error');
            return false;
        }
    }
}
