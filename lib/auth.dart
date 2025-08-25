import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:myapp/config.dart';

final userPool = CognitoUserPool(
  Config.cognitoUserPoolId, // userPoolId
  Config.cognitoClientId, // clientId
);

class Auth {
  static Future<String?> signUp(String email, String password) async {
    try {
      await userPool.signUp(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> confirmSignUp(String email, String code) async {
    final user = CognitoUser(email, userPool);
    try {
      await user.confirmRegistration(code);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String?> signIn(String email, String password) async {
    final user = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );
    try {
      final session = await user.authenticateUser(authDetails);
      return (session != null && session.isValid()) 
        ? "Valid Session" 
        : "Invalid Session";
    } catch (e) {
      return e.toString();
    }
  }
}
