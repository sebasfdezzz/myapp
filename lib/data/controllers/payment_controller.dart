import 'dart:convert';
import 'package:http/http.dart' as http;
import '../global_data.dart';
import '../../api.dart';
import '../../logs.dart';
import '../entities/payment.dart';

class PaymentController {
    static Future<bool> createPayment(Payment payment) async {
        try {
            http.Response response = await PaymentsApi.createPayment(payment);
            
            if (response.statusCode == 200 || response.statusCode == 201) {
                await traceInfo('PaymentController', 'Payment created successfully');
                return true;
            } else {
                await traceError('PaymentController', 'Failed to create payment: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PaymentController', 'Error creating payment: $error');
            return false;
        }
    }

    static Future<Payment?> getPayment(String paymentId) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PaymentsApi.getPayment(clientId, paymentId);
            
            if (response.statusCode == 200) {
                Map<String, dynamic> json = jsonDecode(response.body);
                Payment? payment = Payment.fromJson(json);
                
                if (payment != null) {
                    await traceInfo('PaymentController', 'Retrieved payment $paymentId');
                } else {
                    await traceError('PaymentController', 'Failed to parse payment $paymentId');
                }
                return payment;
            } else {
                await traceError('PaymentController', 'Failed to get payment: ${response.statusCode} - ${response.body}');
                return null;
            }
        } catch (error) {
            await traceError('PaymentController', 'Error getting payment: $error');
            return null;
        }
    }

    static Future<List<Payment>> getPaymentsByClient() async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PaymentsApi.getPaymentsByClient(clientId);
            
            if (response.statusCode == 200) {
                List<dynamic> jsonList = jsonDecode(response.body);
                List<Payment> payments = jsonList
                    .map((json) => Payment.fromJson(json))
                    .where((payment) => payment != null)
                    .cast<Payment>()
                    .toList();
                
                await traceInfo('PaymentController', 'Retrieved ${payments.length} payments');
                return payments;
            } else {
                await traceError('PaymentController', 'Failed to get payments: ${response.statusCode} - ${response.body}');
                return [];
            }
        } catch (error) {
            await traceError('PaymentController', 'Error getting payments: $error');
            return [];
        }
    }

    static Future<bool> updatePayment(Payment payment) async {
        try {
            http.Response response = await PaymentsApi.updatePayment(payment);
            
            if (response.statusCode == 200) {
                await traceInfo('PaymentController', 'Payment updated successfully');
                return true;
            } else {
                await traceError('PaymentController', 'Failed to update payment: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PaymentController', 'Error updating payment: $error');
            return false;
        }
    }

    static Future<bool> patchPayment(String paymentId, Map<String, dynamic> updates) async {
        try {
            String clientId = GlobalData.client.clientId;
            http.Response response = await PaymentsApi.patchPayment(clientId, paymentId, updates);
            
            if (response.statusCode == 200) {
                await traceInfo('PaymentController', 'Payment patched successfully');
                return true;
            } else {
                await traceError('PaymentController', 'Failed to patch payment: ${response.statusCode} - ${response.body}');
                return false;
            }
        } catch (error) {
            await traceError('PaymentController', 'Error patching payment: $error');
            return false;
        }
    }

    static Future<List<Payment>> getActivePayments() async {
        try {
            List<Payment> allPayments = await getPaymentsByClient();
            List<Payment> activePayments = allPayments.where((payment) => 
                payment.status == 'SUCCESSFUL' || payment.status == 'ACTIVE'
            ).toList();
            
            await traceInfo('PaymentController', 'Retrieved ${activePayments.length} active payments');
            return activePayments;
        } catch (error) {
            await traceError('PaymentController', 'Error getting active payments: $error');
            return [];
        }
    }

    static Future<List<Payment>> getPendingPayments() async {
        try {
            List<Payment> allPayments = await getPaymentsByClient();
            List<Payment> pendingPayments = allPayments.where((payment) => 
                payment.status == 'PENDING'
            ).toList();
            
            await traceInfo('PaymentController', 'Retrieved ${pendingPayments.length} pending payments');
            return pendingPayments;
        } catch (error) {
            await traceError('PaymentController', 'Error getting pending payments: $error');
            return [];
        }
    }

    static Future<bool> markPaymentAsSuccessful(String paymentId) async {
        return await patchPayment(paymentId, {'status': 'SUCCESSFUL'});
    }

    static Future<bool> markPaymentAsFailed(String paymentId) async {
        return await patchPayment(paymentId, {'status': 'FAILED'});
    }
}
