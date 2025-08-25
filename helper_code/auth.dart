import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import 'package:myapp/amplifyconfiguration.dart';
import 'package:myapp/config.dart';
import 'package:myapp/controllers/global_data.dart';
import 'package:myapp/controllers/logs.dart';

class RecoveryData {
  String? email;
  String? newPassword;
  String? confirmationCode;

  RecoveryData();
}

class Auth {
  // _user is meant to be used to check if there is a user logged in, null indicates not.
  // ignore: unused_field
  static AuthUser? _user;

  //meant to temporarily hold the information neccesary to recover an account
  // ignore: prefer_final_fields
  static RecoveryData _recoveryData = RecoveryData();

  static RecoveryData getRecoveryData() {
    return _recoveryData;
  }

  static void setRecoveryData({email, newPassword, confirmationCode}) {
    if (email != null) _recoveryData.email = email;
    if (newPassword != null) _recoveryData.newPassword = newPassword;
    if (confirmationCode != null) {
      _recoveryData.confirmationCode = confirmationCode;
    }
  }

  static Future<void> init() async {
    await _configureAmplify();
    _user = await safeGetCurrentUser();
    traceInfo('default',"Current user: ${_user?.toString()}");
    if (Config.autoSignOut) {
      await signOutCurrentUser();
    }
    try {
      if (_user != null) {
        bool success =
            await GlobalData.populateUserDependantGlobalData("CurrentSignedIn");
        if (!success) throw Exception("Error populating user data, current signed in path returned false");
      }
    } catch (e) {
      forceUserNull(e);
    }

    traceInfo('default',
        'User logged in? ${_user != null}. User info populated? ${GlobalData.userInfo.toString()}');
  }

  static void forceUserNull(Object e) {
    _user = null;
    signOutCurrentUser(forceSignOut: true);
    traceError('default','Error populating user data: $e, _user will be set to null');
  }

  static Future<AuthUser?> safeGetCurrentUser() async {
    try {
      return await Amplify.Auth.getCurrentUser();
    } catch (e) {
      traceInfo('default','No user signed in.');
      return null;
    }
  }

  static Future<Map<String, String>?> fetchUserDetails() async {
    if (_user == null) return null;
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userAttributesMap = {
        for (var attr in attributes)
          attr.userAttributeKey.toString(): attr.value,
      };
      return userAttributesMap;
    } catch (e) {
      traceError('default','Error fetching user details: $e');
      return null;
    }
  }

  static bool isUserSignedIn() {
    if (Config.testModeAWS) {
      if (Config.testModeAutoLogin) {
        return true;
      }
      return false;
    }
    return _user != null;
  }

  static Future<bool> signOutCurrentUser({forceSignOut = false}) async {
    if (Config.testModeAWS) return true;
    if (_user == null && !forceSignOut) return false;
    try {
      final result = await Amplify.Auth.signOut();
      if (result is CognitoCompleteSignOut) {
        traceInfo('default','Sign out completed successfully');
        _user = null;
        GlobalData.deleteUserData();
        return true;
      } else if (result is CognitoFailedSignOut) {
        traceError('default','Error signing user out: ${result.exception.message}');
      }
    } catch (e) {
      traceError('default','No user is currently signed in: $e');
    }
    return false;
  }

  static Future<void> _configureAmplify() async {
    try {
      final auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      traceError('default','An error occurred configuring Amplify: $e');
    }
  }

  // Sign Up
  static Future<bool> preSignUp() async {
    if (Config.testModeAWS) return true;
    try {
      if (!GlobalData.userInfo.isCompleteForSignUp()) {
        throw Exception(
            "User Info is incomplete: ${GlobalData.userInfo.toString()}");
      }
      final userAttributes = {
        CognitoUserAttributeKey.email: GlobalData.userInfo.email!,
        CognitoUserAttributeKey.phoneNumber: GlobalData.userInfo.phoneNumber!,
        CognitoUserAttributeKey.birthdate: GlobalData.userInfo.birthdate!,
        CognitoUserAttributeKey.gender: GlobalData.userInfo.gender!,
        CognitoUserAttributeKey.givenName: GlobalData.userInfo.givenName!,
        CognitoUserAttributeKey.familyName: GlobalData.userInfo.familyName!,
        const CognitoUserAttributeKey.custom('things_to_learn'):
            GlobalData.userInfo.thingsToLearn!,
        const CognitoUserAttributeKey.custom('motivations'):
            GlobalData.userInfo.motivations!,
        const CognitoUserAttributeKey.custom('age'):
            GlobalData.userInfo.age!.toString(),
      };

      // final result =
      await Amplify.Auth.signUp(
        username: GlobalData.userInfo.email!,
        password: GlobalData.userInfo.password!,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );

      // await _handleSignUpResult(result);
      return true;
    } on AuthException catch (e) {
      traceError('default','Error signing up user: ${e.message}');
      return false;
    }
  }

  // static Future<void> _handleSignUpResult(SignUpResult result) async {
  //   switch (result.nextStep.signUpStep) {
  //     case AuthSignUpStep.confirmSignUp:
  //       final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
  //       _handleCodeDelivery(codeDeliveryDetails);
  //       break;
  //     case AuthSignUpStep.done:
  //       traceInfo('default','Sign up is complete');
  //       break;
  //   }
  // }

  // static void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
  //   traceInfo('default',
  //     'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
  //     'Check ${codeDeliveryDetails.deliveryMedium.name} for the code.',
  //   );
  // }

  // Email Code Confirmation
  static Future<bool> confirmSignUp(confirmationCode) async {
    if (Config.testModeAWS) return true;
    try {
      //final result =
      await Amplify.Auth.confirmSignUp(
        username: GlobalData.userInfo.email!,
        confirmationCode: confirmationCode,
      );
      return true;
    } on AuthException catch (e) {
      traceError('default','Error confirming user: ${e.message}');
      return false;
    }
  }

  // Sign In
  static Future<bool> signIn(String email, String password) async {
    if (Config.testModeAWS) {
      GlobalData.testPopulateGlobalData();
      return true;
    }
    //await signOutCurrentUser(forceSignOut: true);
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      // await _handleSignInResult(result, username: email);
      if (result.nextStep.signInStep != AuthSignInStep.done) return false;
      traceInfo('default','Sign in is complete');
      _user = await safeGetCurrentUser();
      traceInfo('default',"signed in user: ${_user?.toString()}");
      traceInfo('default',"user info: ${GlobalData.userInfo.toString()}");
      if (GlobalData.userInfo.isEmpty()) {
        traceInfo('default',"going sign in way");
        await GlobalData.populateUserDependantGlobalData("SignIn");
      } else {
        traceInfo('default',"going sign up way");
        await GlobalData.populateUserDependantGlobalData("SignUp");
      }
      return true;
    } on AuthException catch (e) {
      traceError('default','Error signing in (email: $email): ${e.message}');
      return false;
    }
  }

  // static Future<void> _handleSignInResult(SignInResult result,
  //     {String? username}) async {
  //   switch (result.nextStep.signInStep) {
  //     case AuthSignInStep.confirmSignInWithSmsMfaCode:
  //       final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
  //       _handleCodeDelivery(codeDeliveryDetails);
  //       break;
  //     case AuthSignInStep.confirmSignInWithNewPassword:
  //       traceInfo('default','Enter a new password to continue signing in');
  //       break;
  //     case AuthSignInStep.confirmSignInWithCustomChallenge:
  //       final parameters = result.nextStep.additionalInfo;
  //       final prompt = parameters['prompt']!;
  //       traceInfo('default',prompt);
  //       break;
  //     case AuthSignInStep.resetPassword:
  //       final resetResult = await Amplify.Auth.resetPassword(
  //         username: username!,
  //       );
  //       await _handleResetPasswordResult(resetResult);
  //       break;
  //     case AuthSignInStep.confirmSignUp:
  //       // Resend the sign up code to the registered device.
  //       final resendResult = await Amplify.Auth.resendSignUpCode(
  //         username: username!,
  //       );
  //       _handleCodeDelivery(resendResult.codeDeliveryDetails);
  //       break;
  //     case AuthSignInStep.done:
  //       traceInfo('default','Sign in is complete');
  //       _user = await safeGetCurrentUser();
  //       if (GlobalData.userInfo == null) await populateUserInfo();
  //       break;
  //     case AuthSignInStep.continueSignInWithMfaSelection:
  //       break;
  //     case AuthSignInStep.continueSignInWithMfaSetupSelection:
  //       break;
  //     case AuthSignInStep.continueSignInWithTotpSetup:
  //       break;
  //     case AuthSignInStep.continueSignInWithEmailMfaSetup:
  //       break;
  //     case AuthSignInStep.confirmSignInWithTotpMfaCode:
  //       break;
  //     case AuthSignInStep.confirmSignInWithOtpCode:
  //       break;
  //   }
  // }

  static Future<bool> resetPassword() async {
    if (Config.testModeAWS) return true;
    try {
      final result = await Amplify.Auth.resetPassword(
        username: _recoveryData.email!,
      );
      if (result.isPasswordReset) {
        traceError('default','Password reset did not require confirmation.');
        return false;
      } else {
        traceInfo('default',
            'Password reset is required. A confirmation code has been sent to your email or phone.');
        return true;
      }
    } on AuthException catch (e) {
      traceError('default','Error resetting password: ${e.message}');
      return false;
    }
  }

  static Future<bool> confirmResetPassword() async {
    if (Config.testModeAWS) return true;
    try {
      await Amplify.Auth.confirmResetPassword(
        username: _recoveryData.email!,
        newPassword: _recoveryData.newPassword!,
        confirmationCode: _recoveryData.confirmationCode!,
      );
      traceInfo('default',
          'Password reset confirmed. You can now sign in with the new password.');
      return true;
    } catch (e) {
      traceError('default','Error confirming password reset: $e');
      return false;
    }
  }
}
