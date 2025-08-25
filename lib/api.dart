import 'package:http/http.dart' as http;

class Api {
  static Future<http.Response> callApi({
    required String method,
    required Uri url,
    String? body,
  }) async {
    final headers = {'Content-Type': 'application/json'};

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
