class Auth {
  void signIn() {}

  void signUp(String email, String name, String user_type, String password) {}

  void verifyEmail(String email, String code) {}

  void register(String email, String code) {}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';

// Sign up user
Future<String?> signUp(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/signup');
  final response = await http.post(url, body: jsonEncode({
    'email': email,
    'password': password,
    'client_id': cognitoClientId,
    'user_pool_id': cognitoUserPoolId,
  }), headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    return null; // Success
  } else {
    return response.body;
  }
}

// Confirm sign up with code
Future<String?> confirmSignUp(String email, String code) async {
  final url = Uri.parse('$apiBaseUrl/confirm');
  final response = await http.post(url, body: jsonEncode({
    'email': email,
    'code': code,
    'client_id': cognitoClientId,
    'user_pool_id': cognitoUserPoolId,
  }), headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    return null;
  } else {
    return response.body;
  }
}

// Sign in user
Future<String?> signIn(String email, String password) async {
  final url = Uri.parse('$apiBaseUrl/signin');
  final response = await http.post(url, body: jsonEncode({
    'email': email,
    'password': password,
    'client_id': cognitoClientId,
    'user_pool_id': cognitoUserPoolId,
  }), headers: {'Content-Type': 'application/json'});
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    globalUserSub = data['sub'];
    return null;
  } else {
    return response.body;
  }
}
}