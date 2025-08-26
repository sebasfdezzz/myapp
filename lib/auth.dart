import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:myapp/config.dart';
import 'package:myapp/logs.dart';

final userPool = CognitoUserPool(
  Config.cognitoUserPoolId, // userPoolId
  Config.cognitoClientId, // clientId
);

class Auth {
  // Helper method to fetch user details and set globalUserSub
  static Future<bool> _setUserSub(CognitoUser user) async {
    try {
      final attributes = await user.getUserAttributes();

      final subAttr = attributes?.firstWhere(
        (attr) => attr.getName() == 'sub',
      );

      Config.globalUserSub = subAttr?.getValue() ?? '';

      traceInfo(
        "User Id Sub",
        Config.globalUserSub?.toString() ?? "null",
      );

      return true;
    } catch (e) {
      traceError("Sign In Exception", e.toString());
      return false;
    }
  }

  static Future<bool> signUp(String email, String password, String name) async {
    try {
      final userAttributes = [
        AttributeArg(name: 'email', value: email),
        AttributeArg(name: 'name', value: name),
        AttributeArg(
          name: 'custom:user_type',
          value: 'client',
        ),
      ];

      final result = await userPool.signUp(
        email,
        password,
        userAttributes: userAttributes,
      );

      await _setUserSub(result.user);
      return true;
    } catch (e) {
      traceError("Sign In Exception", e.toString());
      return false;
    }
  }

  static Future<bool> confirmSignUp(String email, String code) async {
    final user = CognitoUser(email, userPool);
    try {
      await user.confirmRegistration(code);
      await _setUserSub(user);
      return true;
    } catch (e) {
      traceError("Sign In Exception", e.toString());
      return false;
    }
  }

  static Future<bool> signIn(String email, String password) async {
    final user = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );
    try {
      final session = await user.authenticateUser(authDetails);
      if (session != null && session.isValid()) {
        await _setUserSub(user);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      traceError("Sign In Exception", e.toString());
      return false;
    }
  }
}
