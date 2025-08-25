import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:myapp/config.dart';
import 'package:myapp/logs.dart';

final userPool = CognitoUserPool(
  Config.cognitoUserPoolId, // userPoolId
  Config.cognitoClientId,   // clientId
);

class Auth {
  // Helper method to fetch user details and set globalUserSub
  static Future<void> _setUserSub(CognitoUser user) async {
    try {
      final attributes = await user.getUserAttributes();
      if (attributes != null) {
        for (final attr in attributes) {
          if (attr.name == 'sub') {
            Config.globalUserSub = attr.value;
            traceInfo("User Id Sub", Config.globalUserSub ?? "null");
            break;
          }
        }
      }
    } catch (e) {
      // You may want to log or handle this, but don’t block auth
      print("Error fetching user attributes: $e");
    }
  }

static Future<String?> signUp(String email, String password, String name) async {
  try {
    final userAttributes = [
      AttributeArg(name: 'email', value: email),
      AttributeArg(name: 'name.formatted', value: name),
      AttributeArg(name: 'custom:user_type', value: 'client'), // custom attribute
    ];

    final result = await userPool.signUp(
      email,
      password,
      userAttributes: userAttributes,
    );

    if (result.user != null) {
      await _setUserSub(result.user!);
    }
    return null;
  } catch (e) {
    return e.toString();
  }
}



  static Future<String?> confirmSignUp(String email, String code) async {
    final user = CognitoUser(email, userPool);
    try {
      await user.confirmRegistration(code);
      await _setUserSub(user);
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
      if (session != null && session.isValid()) {
        await _setUserSub(user);
        return null;
      } else {
        return "Invalid Session";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
