import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/pairing.dart';

class PairingController {
    static Future<bool> createSinglePairing(String dishId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PairingsApi.createSinglePairing(clientId, dishId);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('PairingController', 'Single pairing created successfully for dish $dishId');
                return true;
            } else {
                await traceError('PairingController', 'Failed to create single pairing: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PairingController', 'Error creating single pairing: $error');
            return false;
        }
    }

    static Future<bool> createMultiplePairings(List<String> dishIds) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PairingsApi.createPairings(clientId, dishIds: dishIds);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('PairingController', 'Multiple pairings created successfully for ${dishIds.length} dishes');
                return true;
            } else {
                await traceError('PairingController', 'Failed to create multiple pairings: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PairingController', 'Error creating multiple pairings: $error');
            return false;
        }
    }

    static Future<bool> createAllPairings() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PairingsApi.createPairings(clientId);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('PairingController', 'All pairings created successfully');
                return true;
            } else {
                await traceError('PairingController', 'Failed to create all pairings: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PairingController', 'Error creating all pairings: $error');
            return false;
        }
    }

    static Future<List<Pairing>> getPairingsByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PairingsApi.getPairingsByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<Pairing> pairings = jsonList
                    .map((json) => Pairing.fromJson(json))
                    .where((pairing) => pairing != null)
                    .cast<Pairing>()
                    .toList();
                
                await traceInfo('PairingController', 'Retrieved ${pairings.length} pairings');
                return pairings;
            } else {
                await traceError('PairingController', 'Failed to get pairings: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('PairingController', 'Error getting pairings: $error');
            return [];
        }
    }

    static Future<Pairing?> getPairing(String dishId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PairingsApi.getPairing(clientId, dishId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Pairing? pairing = Pairing.fromJson(json);
                
                if (pairing != null) {
                    await traceInfo('PairingController', 'Retrieved pairing for dish $dishId');
                } else {
                    await traceError('PairingController', 'Failed to parse pairing for dish $dishId');
                }
                return pairing;
            } else {
                await traceError('PairingController', 'Failed to get pairing: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('PairingController', 'Error getting pairing: $error');
            return null;
        }
    }
}