import 'dart:math';
import 'package:uuid/uuid.dart';

import '../../logs.dart';

var example_json = {
 "pk": "CLIENT-1234",
 "sk": "CLIENT",
 "address": "Calle Serrano 50",
 "auto_renewal_enabled": true,
 "city": "Madrid",
 "client_name": "Wine Bistro",
 "cognito_id": "21310231823",
 "country": "Spain",
 "entity_type": "Client",
 "last_buy_time": "2025-08-01T19:30:00Z",
 "last_expire_date": "2025-09-01T00:00:00Z",
 "latitude": "40.432",
 "longitude": "-3.678",
 "neighborhood": "Salamanca",
 "plan_type": "Premium",
 "register_date": "2024-03-10T15:00:00Z",
 "status": "ACTIVE",
 "zip_code": "28006"
};

class Client {
    String pk;
    String sk;
    String clientId;
    String address;
    bool autoRenewalEnabled;
    String city;
    String clientName;
    String cognitoId;
    String country;
    String entityType;
    String lastBuyTime;
    String lastExpireDate;
    String latitude;
    String longitude;
    String neighborhood;
    String planType;
    String registerDate;
    String status;
    String zipCode;

    Client._internal({
        required this.pk,
        required this.sk,
        required this.clientId,
        required this.address,
        required this.autoRenewalEnabled,
        required this.city,
        required this.clientName,
        required this.cognitoId,
        required this.country,
        required this.entityType,
        required this.lastBuyTime,
        required this.lastExpireDate,
        required this.latitude,
        required this.longitude,
        required this.neighborhood,
        required this.planType,
        required this.registerDate,
        required this.status,
        required this.zipCode,
    });

    factory Client({
        required String clientName,
        required String cognitoId,
        required String address,
        required String city,
        required String country,
        required String latitude,
        required String longitude,
        required String neighborhood,
        required String zipCode,
        required String planType,
        bool autoRenewalEnabled = true,
        String status = 'ACTIVE',
    }) {
        final clientId = _generateId();
        return Client._internal(
            pk: 'CLIENT-$clientId',
            sk: 'CLIENT',
            clientId: clientId,
            address: address,
            autoRenewalEnabled: autoRenewalEnabled,
            city: city,
            clientName: clientName,
            cognitoId: cognitoId,
            country: country,
            entityType: 'Client',
            lastBuyTime: '',
            lastExpireDate: '',
            latitude: latitude,
            longitude: longitude,
            neighborhood: neighborhood,
            planType: planType,
            registerDate: DateTime.now().toIso8601String(),
            status: status,
            zipCode: zipCode,
        );
    }

    static String _generateId() {
        return Uuid().v4();
    }

    static Client? fromJson(Map<String, dynamic> json) {
        try {
            String pk = json['pk'];
            List<String> pkParts = pk.split("-");
            
            return Client._internal(
                pk: pk,
                sk: json['sk'],
                clientId: pkParts[1],
                address: json['address'],
                autoRenewalEnabled: json['auto_renewal_enabled'],
                city: json['city'],
                clientName: json['client_name'],
                cognitoId: json['cognito_id'],
                country: json['country'],
                entityType: json['entity_type'],
                lastBuyTime: json['last_buy_time'] ?? '',
                lastExpireDate: json['last_expire_date'] ?? '',
                latitude: json['latitude'],
                longitude: json['longitude'],
                neighborhood: json['neighborhood'],
                planType: json['plan_type'],
                registerDate: json['register_date'],
                status: json['status'],
                zipCode: json['zip_code'],
            );
        } catch (error) {
            traceError('default', 'Error parsing Client from JSON: $error');
            traceError('default', 'Offending JSON: $json');
            return null;
        }
    }

    Map<String, dynamic> toJson() {
        return {
            'pk': pk,
            'sk': sk,
            'address': address,
            'auto_renewal_enabled': autoRenewalEnabled,
            'city': city,
            'client_name': clientName,
            'cognito_id': cognitoId,
            'country': country,
            'entity_type': entityType,
            'last_buy_time': lastBuyTime,
            'last_expire_date': lastExpireDate,
            'latitude': latitude,
            'longitude': longitude,
            'neighborhood': neighborhood,
            'plan_type': planType,
            'register_date': registerDate,
            'status': status,
            'zip_code': zipCode,
        };
    }
}