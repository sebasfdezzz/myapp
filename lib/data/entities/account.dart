import 'package:uuid/uuid.dart';

import '../../logs.dart';

var json_example = {
 "pk": "ACCOUNT-5555",
 "sk": "ACCOUNT",
 "client_ids": [
  "1234",
  "5678"
 ],
 "cognito_id": "21310231824",
 "entity_type": "Account",
 "status": "ACTIVE"
};

class Account {
    String pk;
    String sk;
    String accountId;
    List<String> clientIds;
    String cognitoId;
    String entityType;
    String status;

    Account._internal({
        required this.pk,
        required this.sk,
        required this.accountId,
        required this.clientIds,
        required this.cognitoId,
        required this.entityType,
        required this.status,
    });

    factory Account({
        required String cognitoId,
        required List<String> clientIds,
        required String status,
    }) {
        final accountId = _generateId();
        return Account._internal(
            pk: 'ACCOUNT-$accountId',
            sk: 'ACCOUNT',
            accountId: accountId,
            clientIds: clientIds,
            cognitoId: cognitoId,
            entityType: 'Account',
            status: status,
        );
    }

    static String _generateId() {
        return Uuid().v4();
    }

    static Account? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            List<String> pkParts = pk.split("-");
            
            return Account._internal(
                pk: pk,
                sk: json['sk'],
                accountId: pkParts[1],
                clientIds: List<String>.from(json['client_ids']),
                cognitoId: json['cognito_id'],
                entityType: json['entity_type'],
                status: json['status'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Account from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'client_ids': clientIds,
            'cognito_id': cognitoId,
            'entity_type': entityType,
            'status': status,
        };
    }
}