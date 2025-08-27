import 'dart:math';
import 'package:uuid/uuid.dart';

import '../../logs.dart';

var json_example = {
 "pk": "CLIENT-1234",
 "sk": "DISH-D100-OPINION-O400",
 "comment": "Great balance between the seafood and the wine.",
 "dish_description": "Rich paella with saffron and mixed seafood",
 "rate": 4,
 "timestamp": "2025-08-20T18:45:00Z",
 "wine_description": "Smooth with cherry notes, medium-bodied, subtle oak",
 "wine_id": "W200"
};

class Opinion {
    String pk;
    String sk;
    String clientId;
    String dishId;
    String opinionId;
    String comment;
    String dishDescription;
    int rate;
    String timestamp;
    String wineDescription;
    String wineId;

    Opinion._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.dishId,
        required this.opinionId,
        required this.comment,
        required this.dishDescription,
        required this.rate,
        required this.timestamp,
        required this.wineDescription,
        required this.wineId,
    });

    factory Opinion({
        required String clientId,
        required String dishId,
        required String wineId,
        required String comment,
        required String dishDescription,
        required String wineDescription,
        required int rate,
    }) {
        final opinionId = _generateId();
        return Opinion._internal(
            pk: 'CLIENT-$clientId',
            sk: 'DISH-$dishId-OPINION-$opinionId',
            clientId: clientId,
            dishId: dishId,
            opinionId: opinionId,
            comment: comment,
            dishDescription: dishDescription,
            rate: rate,
            timestamp: DateTime.now().toIso8601String(),
            wineDescription: wineDescription,
            wineId: wineId,
        );
    }

    static String _generateId() {
        return Uuid().v4();
    }

    static Opinion? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            String sk = json['sk'];
            List<String> pkParts = pk.split("-");
            List<String> skParts = sk.split("-");
            
            return Opinion._internal(
                pk: pk,
                sk: sk,
                clientId: pkParts[1],
                dishId: skParts[1],
                opinionId: skParts[3],
                comment: json['comment'],
                dishDescription: json['dish_description'],
                rate: json['rate'],
                timestamp: json['timestamp'],
                wineDescription: json['wine_description'],
                wineId: json['wine_id'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Opinion from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'comment': comment,
            'dish_description': dishDescription,
            'rate': rate,
            'timestamp': timestamp,
            'wine_description': wineDescription,
            'wine_id': wineId,
        };
    }
}