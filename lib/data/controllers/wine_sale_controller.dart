import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/wine_sale.dart';

class WineSaleController {
    static Future<bool> createWineSale(WineSale wineSale) async {
        try {
            http.Response response = await WineSalesApi.createWineSale(wineSale);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('WineSaleController', 'Wine sale created successfully');
                return true;
            } else {
                await traceError('WineSaleController', 'Failed to create wine sale: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('WineSaleController', 'Error creating wine sale: $error');
            return false;
        }
    }

    static Future<WineSale?> getWineSale(String wineId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await WineSalesApi.getWineSale(clientId, wineId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                WineSale? wineSale = WineSale.fromJson(json);
                
                if (wineSale != null) {
                    await traceInfo('WineSaleController', 'Retrieved wine sale for wine $wineId');
                } else {
                    await traceError('WineSaleController', 'Failed to parse wine sale for wine $wineId');
                }
                return wineSale;
            } else {
                await traceError('WineSaleController', 'Failed to get wine sale: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('WineSaleController', 'Error getting wine sale: $error');
            return null;
        }
    }

    static Future<List<WineSale>> getWineSalesByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await WineSalesApi.getWineSalesByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<WineSale> wineSales = jsonList
                    .map((json) => WineSale.fromJson(json))
                    .where((wineSale) => wineSale != null)
                    .cast<WineSale>()
                    .toList();
                
                await traceInfo('WineSaleController', 'Retrieved ${wineSales.length} wine sales');
                return wineSales;
            } else {
                await traceError('WineSaleController', 'Failed to get wine sales: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('WineSaleController', 'Error getting wine sales: $error');
            return [];
        }
    }

    static Future<List<WineSale>> getWineSalesByWine(String wineId) async {
        try {
            List<WineSale> allSales = await getWineSalesByClient();
            List<WineSale> wineSales = allSales.where((sale) => sale.wineId == wineId).toList();
            
            await traceInfo('WineSaleController', 'Retrieved ${wineSales.length} sales for wine $wineId');
            return wineSales;
        } catch (error) {
            await traceError('WineSaleController', 'Error getting wine sales by wine: $error');
            return [];
        }
    }

    static Future<List<WineSale>> getWineSalesByDateRange(DateTime startDate, DateTime endDate) async {
        try {
            List<WineSale> allSales = await getWineSalesByClient();
            List<WineSale> filteredSales = allSales.where((sale) {
                DateTime saleDate = DateTime.parse(sale.saleDate);
                return saleDate.isAfter(startDate) && saleDate.isBefore(endDate);
            }).toList();
            
            await traceInfo('WineSaleController', 'Retrieved ${filteredSales.length} sales in date range');
            return filteredSales;
        } catch (error) {
            await traceError('WineSaleController', 'Error getting wine sales by date range: $error');
            return [];
        }
    }

    static Future<int> getTotalSalesAmount() async {
        try {
            List<WineSale> allSales = await getWineSalesByClient();
            int totalAmount = allSales.map((sale) => sale.amount).fold(0, (a, b) => a + b);
            
            await traceInfo('WineSaleController', 'Total sales amount: $totalAmount');
            return totalAmount;
        } catch (error) {
            await traceError('WineSaleController', 'Error calculating total sales amount: $error');
            return 0;
        }
    }

    static Future<Map<String, int>> getSalesByWine() async {
        try {
            List<WineSale> allSales = await getWineSalesByClient();
            Map<String, int> salesByWine = {};
            
            for (WineSale sale in allSales) {
                if (salesByWine.containsKey(sale.wineId)) {
                    salesByWine[sale.wineId] = salesByWine[sale.wineId]! + sale.amount;
                } else {
                    salesByWine[sale.wineId] = sale.amount;
                }
            }
            
            await traceInfo('WineSaleController', 'Generated sales report for ${salesByWine.length} wines');
            return salesByWine;
        } catch (error) {
            await traceError('WineSaleController', 'Error generating sales by wine: $error');
            return {};
        }
    }

    static Future<bool> recordWineSale(String wineId, int amount) async {
        try {
            String clientId = GlobalData.client.clientId;
            WineSale wineSale = WineSale(
                clientId: clientId,
                wineId: wineId,
                amount: amount,
            );
            
            return await createWineSale(wineSale);
        } catch (error) {
            await traceError('WineSaleController', 'Error recording wine sale: $error');
            return false;
        }
    }
}
