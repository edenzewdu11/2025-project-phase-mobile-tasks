class Product {
  final String id; // Unique identifier for the product
  String title;
  String description;
  final String imageUrl; // URL for the product image
  double price; // Price of the product

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  // Helper method to create a copy with updated values (useful for editing)
  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }
}