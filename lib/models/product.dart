class Product {
  final int id;
  final String name;
  final String image;
  final double price;
  final String? details;
  final String? subtitle;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.details,
    this.subtitle,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        image: json['main_image'] ?? json['image'] ?? '',
        price: (json['price'] is int) ? (json['price'] as int).toDouble() : (json['price'] ?? 0).toDouble(),
        details: json['details'],
        subtitle: json['brand'] ?? json['type'] ?? json['details'],
      );
}