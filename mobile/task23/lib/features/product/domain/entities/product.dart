import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String imageUrl;
  final String name;
  final double price;
  final String description;

  const Product({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.description,
  });

  @override
  List<Object> get props => [id];

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? description,
    String? imageUrl,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
