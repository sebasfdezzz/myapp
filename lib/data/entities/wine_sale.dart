import 'dart:math';
import '../../logs.dart';

var example_json = {
  "pk": "CLIENT-1234",
  "sk": "WINE-W200-WINESALE-WS500",
  "amount": 1,
  "entity_type": "WineSale",
  "sale_date": "2025-08-15T18:45:00Z"
};

class WineSale {
    String pk;
    String sk;
    String clientId;
    String wineId;
    String wineSaleId;
    int amount;
    String entityType;
    String saleDate;

    WineSale._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.wineId,
        required this.wineSaleId,
        required this.amount,
        required this.entityType,
        required this.saleDate,
    });

    factory WineSale({
        required String clientId,
        required String wineId,
        required int amount,
    }) {
        final wineSaleId = _generateId();
        return WineSale._internal(
            pk: 'CLIENT-$clientId',
            sk: 'WINE-$wineId-WINESALE-$wineSaleId',
            clientId: clientId,
            wineId: wineId,
            wineSaleId: wineSaleId,
            amount: amount,
            entityType: 'WineSale',
            saleDate: DateTime.now().toIso8601String(),
        );
    }

    static String _generateId() {
        return 'WS${Random().nextInt(999999).toString().padLeft(6, '0')}';
    }

    static WineSale? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            String sk = json['sk'];
            List<String> pkParts = pk.split("-");
            List<String> skParts = sk.split("-");
            
            return WineSale._internal(
                pk: pk,
                sk: sk,
                clientId: pkParts[1],
                wineId: skParts[1],
                wineSaleId: skParts[3],
                amount: json['amount'],
                entityType: json['entity_type'],
                saleDate: json['sale_date'],
            );
        } catch (error) {
            traceError('default', 'Error parsing WineSale from JSON: $error');
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
            'sale_date': saleDate,
        };
    }
}