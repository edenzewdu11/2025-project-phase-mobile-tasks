// lib/core/entities/product.dart
import 'package:equatable/equatable.dart'; // ADDED

class Product extends Equatable { // MODIFIED - extends Equatable
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  const Product({
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

  @override
  List<Object> get props => [id, title, description, imageUrl, price]; // ADDED for Equatable

  @override
  bool get stringify => true; // Optional: for better toString() output
}