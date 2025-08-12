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
    final id = json['id'] as String?;
    final name = json['name'] as String?;
    final imageUrl = json['imageUrl'] as String?;
    final price = json['price'] as num?;
    final description = json['description'] as String?;
    
    if (id == null || name == null || imageUrl == null || price == null || description == null) {
      throw Exception('Invalid response format: required fields are missing');
    }
    
    return ProductModel(
      id: id,
      name: name,
      imageUrl: imageUrl,
      price: price.toDouble(), // handles 1 or 1.0
      description: description,
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
