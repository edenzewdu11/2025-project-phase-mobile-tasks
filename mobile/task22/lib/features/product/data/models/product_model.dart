import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.imageUrl,
    required super.name,
    required super.price,
    required super.description,
  });

  @override
  List<Object> get props => [id];

  // ✅ Add this method to convert from domain entity → model
  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
      description: product.description,
    );
  }

  // 🧠 Important: fromJson converts Map → ProductModel
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: (json['price'] as num).toDouble(), // handles 1 or 1.0
      description: json['description'],
    );
  }

  /// 🔄 Converts Dart object → Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'description': description,
    };
  }
}
