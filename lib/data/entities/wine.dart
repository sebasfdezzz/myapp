import 'package:uuid/uuid.dart';

import '../../logs.dart';

var json_example = {
  "pk": "CLIENT-1234",
  "sk": "WINE-W200",
  "available_items": 120,
  "capacity": 700,
  "country": "ES",
  "description": "Elegant red with oak notes",
  "entity_type": "WineBasic",
  "grape_variety": ["Tempranillo"],
  "image_url": "link",
  "name": "Rioja Reserva",
  "price": 40000,
  "glass_price": 15000,
  "producer": "Barrica slopo",
  "region": "La Rioja",
  "status": "IN_STOCK",
  "tasting": "Cherry, vanilla, leather",
  "type": "Red",
};

class Wine {
  String pk;
  String sk;
  String clientId;
  String wineId;
  int availableItems;
  int capacity;
  String country;
  String description;
  String entityType;
  List<String> grapeVariety;
  String imageUrl;
  String name;
  int price;
  int glassPrice;
  String producer;
  String region;
  String status;
  String tasting;
  String type;

  Wine._internal({
    required this.pk,
    required this.sk,
    required this.clientId,
    required this.wineId,
    required this.availableItems,
    required this.capacity,
    required this.country,
    required this.description,
    required this.entityType,
    required this.grapeVariety,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.glassPrice,
    required this.producer,
    required this.region,
    required this.status,
    required this.tasting,
    required this.type,
  });

  factory Wine({
    required String clientId,
    required String name,
    required String description,
    required String country,
    required String region,
    required String producer,
    required String type,
    required List<String> grapeVariety,
    required int price,
    required int glassPrice,
    required int capacity,
    required int availableItems,
    required String tasting,
    String imageUrl = '',
    String status = 'IN_STOCK',
  }) {
    final wineId = _generateId();
    return Wine._internal(
      pk: 'CLIENT-$clientId',
      sk: 'WINE-$wineId',
      clientId: clientId,
      wineId: wineId,
      availableItems: availableItems,
      capacity: capacity,
      country: country,
      description: description,
      entityType: 'Wine',
      grapeVariety: grapeVariety,
      imageUrl: imageUrl,
      name: name,
      price: price,
      glassPrice: glassPrice,
      producer: producer,
      region: region,
      status: status,
      tasting: tasting,
      type: type,
    );
  }

  static String _generateId() {
    return Uuid().v4();
  }

  static Wine? fromJson(Map<String, dynamic> json) {
    try {
      String pk = json['pk'];
      String sk = json['sk'];
      List<String> pkParts = pk.split("-");
      List<String> skParts = sk.split("-");

      return Wine._internal(
        pk: pk,
        sk: sk,
        clientId: pkParts[1],
        wineId: skParts[1],
        availableItems: json['available_items'],
        capacity: json['capacity'],
        country: json['country'],
        description: json['description'],
        entityType: json['entity_type'],
        grapeVariety: List<String>.from(json['grape_variety']),
        imageUrl: json['image_url'] ?? '',
        name: json['name'],
        price: json['price'],
        glassPrice: json['glass_price'],
        producer: json['producer'],
        region: json['region'],
        status: json['status'],
        tasting: json['tasting'],
        type: json['type'],
      );
    } catch (error) {
      traceError('default', 'Error parsing Wine from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'sk': sk,
      'available_items': availableItems,
      'capacity': capacity,
      'country': country,
      'description': description,
      'entity_type': entityType,
      'grape_variety': grapeVariety,
      'image_url': imageUrl,
      'name': name,
      'price': price,
      'glass_price': glassPrice,
      'producer': producer,
      'region': region,
      'status': status,
      'tasting': tasting,
      'type': type,
    };
  }
}

class WineBasic {
  String pk;
  String sk;
  String clientId;
  String wineId;
  String name;

  WineBasic._internal({
    required this.pk,
    required this.sk,
    required this.clientId,
    required this.wineId,
    required this.name,
  });

  factory WineBasic({required String clientId, required String name}) {
    final wineId = _generateId();
    return WineBasic._internal(
      pk: 'CLIENT-$clientId',
      sk: 'WINEBASIC-$wineId',
      clientId: clientId,
      wineId: wineId,
      name: name,
    );
  }

  static String _generateId() {
    return Uuid().v4();
  }

  static WineBasic? fromJson(Map<String, dynamic> json) {
    try {
      String pk = json['pk'];
      String sk = json['sk'];
      List<String> pkParts = pk.split("-");
      List<String> skParts = sk.split("-");

      return WineBasic._internal(
        pk: pk,
        sk: sk,
        clientId: pkParts[1],
        wineId: skParts[1],
        name: json['name'],
      );
    } catch (error) {
      traceError('default', 'Error parsing Wine from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pk': pk,
      'sk': sk,
      'name': name,
    };
  }
}
