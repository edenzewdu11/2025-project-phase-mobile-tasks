// lib/features/product/data/models/product_model.dart

import '../../../../core/entities/product.dart'; // Ensure this path is correct

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.title,
    required super.description,
    required super.imageUrl,
    required super.price,
  });

  // Factory constructor to create a ProductModel from a JSON map
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }

  // Method to convert a ProductModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  // Factory constructor to create a ProductModel from a Product entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      imageUrl: entity.imageUrl,
      price: entity.price,
    );
  }

  // IMPORTANT: ADDED/CORRECTED THIS 'copyWith' METHOD IN ProductModel
  // It uses the super's copyWith but then casts the result back to ProductModel
  // Or, more robustly, reconstructs a ProductModel.
  // For simplicity, we'll delegate to super.copyWith and then make a new ProductModel.
  @override // Mark as override to ensure it's overriding the base class's copyWith
  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    double? price,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
    );
  }


  // Method to convert a ProductModel back to a Product entity (useful for domain layer)
  Product toEntity() {
    return Product(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );
  }
}