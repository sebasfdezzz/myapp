import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'data/entities/account.dart';
import 'data/entities/client.dart';
import 'data/entities/dish.dart';
import 'data/entities/opinion.dart';
import 'data/entities/pairing.dart';
import 'data/entities/payment.dart';
import 'data/entities/wine.dart';
import 'data/entities/wine_sale.dart';

// # POST /clients
// # GET,PUT,PATCH /clients/{clientId} pk = CLIENT-1234, sk = CLIENT, clientId = 1234
// # GET /clients/cognito/{cognitoId} GSI Name: ClientIdByCognitoSub, attribute cognito_id = <cognitoId>

// # POST /accounts
// # GET,PUT,PATCH /accounts/{accountId} pk = ACCOUNT-5555, sk = ACCOUNT, account_id = 5555
// # GET /accounts/cognito/{cognitoId} GSI Name: ClientIdByCognitoSub, attribute cognito_id = <cognitoId>

// # GET,PUT,PATCH /dishes/{clientId}/{dishId} pk = CLIENT-1234, sk = DISH-D100, clientId = 1234, dishId = D100
// # GET,POST /dishes/{clientId} pk = CLIENT-1234, sk start with DISH

// # GET,POST /pairings/{clientId}/{dishId} pk = CLIENT-1234, sk = PAIRING-D100, clientId = 1234, dishId = D100 (one pairing per dish, POST triggers async lambda)
// # GET,POST /pairings/{clientId} pk = CLIENT-1234, sk start contains PAIRING, clientId = 1234 (POST is create all pairings, no body required)

// # GET,PUT,PATCH /payments/{clientId}/{paymentId} pk = CLIENT-1234, sk = PAYMENT-9876, clientId = 1234, paymentId = 9876
// # GET,POST /payments/{clientId} pk = CLIENT-1234, sk start with PAYMENT, clientId = 1234

// # GET,PUT,PATCH /wines/{clientId}/{wineId} pk = CLIENT-1234, sk = WINE-W200, clientId = 1234, wineId = W200
// # GET,POST /wines/{clientId} pk = CLIENT-1234, sk start with WINE, clientId = 1234

// # GET,POST /wine_sales/{clientId}/{wineId} pk = CLIENT-1234, sk = WINE-W200-WINESALE-WS500, clientId = 1234, wineId = W200
// # GET /wine_sales/{clientId} pk = CLIENT-1234, sk contains WINESALE, clientId = 1234

// # GET,POST /opinions/{clientId}/{dishId} pk = CLIENT-1234, sk = DISH-D100-OPINION-O400, clientId = 1234, dishId = D100
// # GET /opinions/{clientId} pk = CLIENT-1234, sk contains OPINION, clientId = 1234

// Base API class
class Api {
  static Future<http.Response> callApi({
    required String method,
    required String path,
    String? body,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse('${Config.apiBaseUrl}$path');

    switch (method) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(url, body: body, headers: headers);
      case 'PUT':
        return await http.put(url, body: body, headers: headers);
      case 'PATCH':
        return await http.patch(url, body: body, headers: headers);
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        return http.Response('Unsupported method', 400);
    }
  }
}

// Accounts API
class AccountsApi extends Api {
  static Future<http.Response> createAccount(Account account) {
    return Api.callApi(
      method: 'POST', 
      path: 'accounts', 
      body: jsonEncode(account.toJson())
    );
  }

  static Future<http.Response> getAccount(String accountId) {
    return Api.callApi(method: 'GET', path: 'accounts/$accountId');
  }

  static Future<http.Response> updateAccount(Account account) {
    return Api.callApi(
      method: 'PUT', 
      path: 'accounts/${account.accountId}', 
      body: jsonEncode(account.toJson())
    );
  }

  static Future<http.Response> patchAccount(String accountId, Map<String, dynamic> updates) {
    return Api.callApi(
      method: 'PATCH', 
      path: 'accounts/$accountId', 
      body: jsonEncode(updates)
    );
  }

  static Future<http.Response> getAccountByCognito(String cognitoId) {
    return Api.callApi(method: 'GET', path: 'accounts/cognito/$cognitoId');
  }
}

// Clients API
class ClientsApi extends Api {
  static Future<http.Response> createClient(Client client) {
    return Api.callApi(
      method: 'POST', 
      path: 'clients', 
      body: jsonEncode(client.toJson())
    );
  }

  static Future<http.Response> getClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'clients/$clientId');
  }

  static Future<http.Response> updateClient(Client client) {
    return Api.callApi(
      method: 'PUT', 
      path: 'clients/${client.clientId}', 
      body: jsonEncode(client.toJson())
    );
  }

  static Future<http.Response> patchClient(String clientId, Map<String, dynamic> updates) {
    return Api.callApi(
      method: 'PATCH', 
      path: 'clients/$clientId', 
      body: jsonEncode(updates)
    );
  }

  static Future<http.Response> getClientByCognito(String cognitoId) {
    return Api.callApi(method: 'GET', path: 'clients/cognito/$cognitoId');
  }
}

// Dishes API
class DishesApi extends Api {
  static Future<http.Response> getDish(String clientId, String dishId) {
    return Api.callApi(method: 'GET', path: 'dishes/$clientId/$dishId');
  }

  static Future<http.Response> updateDish(Dish dish) {
    return Api.callApi(
      method: 'PUT', 
      path: 'dishes/${dish.clientId}/${dish.dishId}', 
      body: jsonEncode(dish.toJson())
    );
  }

  static Future<http.Response> patchDish(String clientId, String dishId, Map<String, dynamic> updates) {
    return Api.callApi(
      method: 'PATCH', 
      path: 'dishes/$clientId/$dishId', 
      body: jsonEncode(updates)
    );
  }

  static Future<http.Response> getDishesByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'dishes/$clientId');
  }

  static Future<http.Response> createDish(Dish dish) {
    return Api.callApi(
      method: 'POST', 
      path: 'dishes/${dish.clientId}', 
      body: jsonEncode(dish.toJson())
    );
  }
}

// Pairings API
class PairingsApi extends Api {
  static Future<http.Response> getPairing(String clientId, String dishId) {
    return Api.callApi(method: 'GET', path: 'pairings/$clientId/$dishId');
  }

  static Future<http.Response> createSinglePairing(String clientId, String dishId) {
    return Api.callApi(method: 'POST', path: 'pairings/$clientId/$dishId');
  }

  static Future<http.Response> getPairingsByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'pairings/$clientId');
  }

  static Future<http.Response> createPairings(String clientId, {List<String>? dishIds}) {
    String body = dishIds != null ? jsonEncode({'dishIds': dishIds}) : '';
    return Api.callApi(method: 'POST', path: 'pairings/$clientId', body: body);
  }
}

// Payments API
class PaymentsApi extends Api {
  static Future<http.Response> getPayment(String clientId, String paymentId) {
    return Api.callApi(method: 'GET', path: 'payments/$clientId/$paymentId');
  }

  static Future<http.Response> updatePayment(Payment payment) {
    return Api.callApi(
      method: 'PUT', 
      path: 'payments/${payment.clientId}/${payment.paymentId}', 
      body: jsonEncode(payment.toJson())
    );
  }

  static Future<http.Response> patchPayment(String clientId, String paymentId, Map<String, dynamic> updates) {
    return Api.callApi(
      method: 'PATCH', 
      path: 'payments/$clientId/$paymentId', 
      body: jsonEncode(updates)
    );
  }

  static Future<http.Response> getPaymentsByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'payments/$clientId');
  }

  static Future<http.Response> createPayment(Payment payment) {
    return Api.callApi(
      method: 'POST', 
      path: 'payments/${payment.clientId}', 
      body: jsonEncode(payment.toJson())
    );
  }
}

// Wines API
class WinesApi extends Api {
  static Future<http.Response> getWine(String clientId, String wineId) {
    return Api.callApi(method: 'GET', path: 'wines/$clientId/$wineId');
  }

  static Future<http.Response> updateWine(Wine wine) {
    return Api.callApi(
      method: 'PUT', 
      path: 'wines/${wine.clientId}/${wine.wineId}', 
      body: jsonEncode(wine.toJson())
    );
  }

  static Future<http.Response> patchWine(String clientId, String wineId, Map<String, dynamic> updates) {
    return Api.callApi(
      method: 'PATCH', 
      path: 'wines/$clientId/$wineId', 
      body: jsonEncode(updates)
    );
  }

  static Future<http.Response> getWinesByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'wines/$clientId');
  }

  static Future<http.Response> createWine(Wine wine) {
    return Api.callApi(
      method: 'POST', 
      path: 'wines/${wine.clientId}', 
      body: jsonEncode(wine.toJson())
    );
  }
}

// Wine Sales API
class WineSalesApi extends Api {
  static Future<http.Response> getWineSale(String clientId, String wineId) {
    return Api.callApi(method: 'GET', path: 'wine_sales/$clientId/$wineId');
  }

  static Future<http.Response> createWineSale(WineSale wineSale) {
    return Api.callApi(
      method: 'POST', 
      path: 'wine_sales/${wineSale.clientId}/${wineSale.wineId}', 
      body: jsonEncode(wineSale.toJson())
    );
  }

  static Future<http.Response> getWineSalesByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'wine_sales/$clientId');
  }
}

// Opinions API
class OpinionsApi extends Api {
  static Future<http.Response> getOpinion(String clientId, String dishId) {
    return Api.callApi(method: 'GET', path: 'opinions/$clientId/$dishId');
  }

  static Future<http.Response> createOpinion(Opinion opinion) {
    return Api.callApi(
      method: 'POST', 
      path: 'opinions/${opinion.clientId}/${opinion.dishId}', 
      body: jsonEncode(opinion.toJson())
    );
  }

  static Future<http.Response> getOpinionsByClient(String clientId) {
    return Api.callApi(method: 'GET', path: 'opinions/$clientId');
  }
}
