import 'dart:math';
import '../../logs.dart';

var json_example = {
 "pk": "CLIENT-1234",
 "sk": "PAIRING-D100",
 "wines": [
  {
   "rank": 1,
   "score": 92,
   "wine_id": "W200"
  },
  {
   "rank": 2,
   "score": 89,
   "wine_id": "W201"
  }
 ]
};

class PairingWine {
    int rank;
    int score;
    String wineId;

    PairingWine({
        required this.rank,
        required this.score,
        required this.wineId,
    });

    static PairingWine? fromJson(Map<String, dynamic> json) {
        try {
            return PairingWine(
                rank: json['rank'],
                score: json['score'],
                wineId: json['wine_id'],
            );
        } catch (error) {
            traceError('default', 'Error parsing PairingWine from JSON: $error');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'rank': rank,
            'score': score,
            'wine_id': wineId,
        };
    }
}

class Pairing {
    String pk;
    String sk;
    String clientId;
    String dishId;
    List<PairingWine> wines;

    Pairing._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.dishId,
        required this.wines,
    });

    factory Pairing({
        required String clientId,
        required String dishId,
        required List<PairingWine> wines,
    }) {
        return Pairing._internal(
            pk: 'CLIENT-$clientId',
            sk: 'PAIRING-$dishId',
            clientId: clientId,
            dishId: dishId,
            wines: wines,
        );
    }

    static Pairing? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            String sk = json['sk'];
            List<String> pkParts = pk.split("-");
            List<String> skParts = sk.split("-");
            
            List<PairingWine> wines = [];
            if (json['wines'] != null) {
                wines = (json['wines'] as List)
                    .map((w) => PairingWine.fromJson(w))
                    .where((w) => w != null)
                    .cast<PairingWine>()
                    .toList();
            }
            
            return Pairing._internal(
                pk: pk,
                sk: sk,
                clientId: pkParts[1],
                dishId: skParts[1],
                wines: wines,
            );
        } catch (error) {
            traceError('default', 'Error parsing Pairing from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'wines': wines.map((w) => w.toJson()).toList(),
        };
    }
}