import 'dart:math';
import '../../logs.dart';
import 'package:uuid/uuid.dart';

var json_example ={
 "pk": "CLIENT-1234",
 "sk": "PAYMENT-9876",
 "amount": 5999,
 "entity_type": "Payment",
 "expire_date": "2025-09-20T12:34:56Z",
 "purchase_time": "2025-08-20T12:34:56Z",
 "status": "SUCCESFUL"
};

class Payment {
    String pk;
    String sk;
    String clientId;
    String paymentId;
    int amount;
    String entityType;
    String expireDate;
    String purchaseTime;
    String status;

    Payment._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.paymentId,
        required this.amount,
        required this.entityType,
        required this.expireDate,
        required this.purchaseTime,
        required this.status,
    });

    factory Payment({
        required String clientId,
        required int amount,
        required String expireDate,
        String status = 'PENDING',
    }) {
        final paymentId = _generateId();
        return Payment._internal(
            pk: 'CLIENT-$clientId',
            sk: 'PAYMENT-$paymentId',
            clientId: clientId,
            paymentId: paymentId,
            amount: amount,
            entityType: 'Payment',
            expireDate: expireDate,
            purchaseTime: DateTime.now().toIso8601String(),
            status: status,
        );
    }

    static String _generateId() {
        return Uuid().v4();
    }

    static Payment? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            String sk = json['sk'];
            List<String> pkParts = pk.split("-");
            List<String> skParts = sk.split("-");
            
            return Payment._internal(
                pk: pk,
                sk: sk,
                clientId: pkParts[1],
                paymentId: skParts[1],
                amount: json['amount'],
                entityType: json['entity_type'],
                expireDate: json['expire_date'],
                purchaseTime: json['purchase_time'],
                status: json['status'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Payment from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'amount': amount,
            'entity_type': entityType,
            'expire_date': expireDate,
            'purchase_time': purchaseTime,
            'status': status,
        };
    }
}