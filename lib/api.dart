import 'package:http/http.dart' as http;

class Api {
  static Future<http.Response> callApi({
    required String method,
    required String path,
    String? body,
  }) async {
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse('${Config.apiUrl}/$path');

    switch (method) {
      case 'GET':
        return await http.get(url);
      case 'POST':
        return await http.post(url, body: body, headers: headers);
      case 'PUT':
        return await http.put(url, body: body, headers: headers);
      case 'DELETE':
        return await http.delete(url);
      default:
        return http.Response('Unsupported method', 400);
    }
  }
}

class WineSalesApi : Api {
  static Future<http.Response> getWineSalesByClient(String clientId) {
    return callApi(method: 'GET', path: 'wine_sales/$clientId');
  }

  static Future<http.Response> createWineSale(WineSale wineSale) {
    return callApi(method: 'POST', path: 'wine_sales/${wineSale.clientId}', body: wineSale.toJson());
  }
}
