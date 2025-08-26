class Wine {
  final String name;
  final String producer;
  final String capacity;
  final String type;
  final double price;
  final double? glassPrice;
  final String description;
  final String country;
  final String region;
  final List<String> grapeVariety;
  final String flag;
  final String? imageUrl;
  final String? maridaje;
  final double? compatibility;

  Wine({
    required this.name,
    required this.producer,
    required this.capacity,
    required this.type,
    required this.price,
    required this.glassPrice,
    required this.description,
    required this.country,
    required this.region,
    required this.grapeVariety,
    required this.flag,
    this.imageUrl,
    this.maridaje,
    this.compatibility,
  });

  factory Wine.fromJson(Map<String, dynamic> json) {
    return Wine(
      name: json['name'],
      producer: json['producer'],
      capacity: json['capacity'],
      type: json['type'],
      price: (json['price'] as num).toDouble(),
      glassPrice:
          json['glass_price'] != null
              ? (json['glass_price'] as num).toDouble()
              : null,
      description: json['description'],
      country: json['country'],
      region: json['region'],
      grapeVariety: List<String>.from(json['grapeVariety'] ?? []),
      flag: json['flag'],
      imageUrl: json['imageUrl'],
      maridaje: json['maridaje'],
      compatibility:
          json['compatibility'] != null
              ? (json['compatibility'] as num).toDouble()
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'price': price,
      'glass_price': glassPrice,
      'description': description,
      'country': country,
      'region': region,
      'grapeVariety': grapeVariety,
      'flag': flag,
      'imageUrl': imageUrl,
      'maridaje': maridaje,
      'compatibility': compatibility,
    };
  }
}