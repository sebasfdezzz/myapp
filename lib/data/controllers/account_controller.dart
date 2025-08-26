import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/account.dart';

class AccountController {
    static Future<bool> createAccount(Account account) async {
        try {
            http.Response response = await AccountsApi.createAccount(account);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('AccountController', 'Account created successfully');
                return true;
            } else {
                await traceError('AccountController', 'Failed to create account: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('AccountController', 'Error creating account: $error');
            return false;
        }
    }

    static Future<Account?> getAccount(String accountId) async {
        try {
            http.Response response = await AccountsApi.getAccount(accountId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Account? account = Account.fromJson(json);
                
                if (account != null) {
                    await traceInfo('AccountController', 'Retrieved account $accountId');
                } else {
                    await traceError('AccountController', 'Failed to parse account $accountId');
                }
                return account;
            } else {
                await traceError('AccountController', 'Failed to get account: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('AccountController', 'Error getting account: $error');
            return null;
        }
    }

    static Future<Account?> getAccountByCognito(String cognitoId) async {
        try {
            http.Response response = await AccountsApi.getAccountByCognito(cognitoId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Account? account = Account.fromJson(json);
                
                if (account != null) {
                    await traceInfo('AccountController', 'Retrieved account by cognito ID');
                } else {
                    await traceError('AccountController', 'Failed to parse account by cognito ID');
                }
                return account;
            } else {
                await traceError('AccountController', 'Failed to get account by cognito: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('AccountController', 'Error getting account by cognito: $error');
            return null;
        }
    }

    static Future<bool> updateAccount(Account account) async {
        try {
            http.Response response = await AccountsApi.updateAccount(account);
            
            if (response.statusCode == 200) {
                await traceInfo('AccountController', 'Account updated successfully');
                return true;
            } else {
                await traceError('AccountController', 'Failed to update account: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('AccountController', 'Error updating account: $error');
            return false;
        }
    }

    static Future<bool> patchAccount(String accountId, Map<String, dynamic> updates) async {
        try {
            http.Response response = await AccountsApi.patchAccount(accountId, updates);
            
            if (response.statusCode == 200) {
                await traceInfo('AccountController', 'Account patched successfully');
                return true;
            } else {
                await traceError('AccountController', 'Failed to patch account: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('AccountController', 'Error patching account: $error');
            return false;
        }
    }
}
