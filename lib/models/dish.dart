class Dish {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Dish({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'image': imageUrl,
    };
  }
}