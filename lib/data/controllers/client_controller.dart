import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/client.dart';

class ClientController {
    static Future<bool> createClient(Client client) async {
        try {
            http.Response response = await ClientsApi.createClient(client);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('ClientController', 'Client created successfully');
                return true;
            } else {
                await traceError('ClientController', 'Failed to create client: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('ClientController', 'Error creating client: $error');
            return false;
        }
    }

    static Future<Client?> getClient(String clientId) async {
        try {
            http.Response response = await ClientsApi.getClient(clientId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Client? client = Client.fromJson(json);
                
                if (client != null) {
                    await traceInfo('ClientController', 'Retrieved client $clientId');
                    GlobalData.client = client; // Update global data
                } else {
                    await traceError('ClientController', 'Failed to parse client $clientId');
                }
                return client;
            } else {
                await traceError('ClientController', 'Failed to get client: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('ClientController', 'Error getting client: $error');
            return null;
        }
    }

    static Future<Client?> getClientByCognito(String cognitoId) async {
        try {
            http.Response response = await ClientsApi.getClientByCognito(cognitoId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Client? client = Client.fromJson(json);
                
                if (client != null) {
                    await traceInfo('ClientController', 'Retrieved client by cognito ID');
                    GlobalData.client = client; // Update global data
                } else {
                    await traceError('ClientController', 'Failed to parse client by cognito ID');
                }
                return client;
            } else {
                await traceError('ClientController', 'Failed to get client by cognito: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('ClientController', 'Error getting client by cognito: $error');
            return null;
        }
    }

    static Future<bool> updateClient(Client client) async {
        try {
            http.Response response = await ClientsApi.updateClient(client);
            
            if (response.statusCode == 200) {
                await traceInfo('ClientController', 'Client updated successfully');
                GlobalData.client = client; // Update global data
                return true;
            } else {
                await traceError('ClientController', 'Failed to update client: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('ClientController', 'Error updating client: $error');
            return false;
        }
    }

    static Future<bool> patchClient(String clientId, Map<String, dynamic> updates) async {
        try {
            http.Response response = await ClientsApi.patchClient(clientId, updates);
            
            if (response.statusCode == 200) {
                await traceInfo('ClientController', 'Client patched successfully');
                // Optionally refresh client data in global state
                return true;
            } else {
                await traceError('ClientController', 'Failed to patch client: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('ClientController', 'Error patching client: $error');
            return false;
        }
    }

    static Future<bool> loadClientToGlobal(String clientId) async {
        Client? client = await getClient(clientId);
        if (client != null) {
            GlobalData.client = client;
            return true;
        }
        return false;
    }

    static Future<bool> loadClientByCognitoToGlobal(String cognitoId) async {
        Client? client = await getClientByCognito(cognitoId);
        if (client != null) {
            GlobalData.client = client;
            return true;
        }
        return false;
    }
}
