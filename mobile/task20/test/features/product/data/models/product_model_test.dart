// test/features/product/data/models/product_model_test.dart

import 'dart:convert'; // For json.encode/decode

import 'package:flutter_test/flutter_test.dart';
import 'package:contracts_of_data_sources/core/entities/product.dart'; // Adjust project name
import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart'; // Adjust project name

void main() {
  const tProductModel = ProductModel(
    id: '123',
    title: 'Test Gadget',
    description: 'A fantastic test gadget.',
    imageUrl: 'http://example.com/image.jpg',
    price: 99.99,
  );

  // Define a map that represents the JSON structure
  final tProductModelMap = {
    'id': '123',
    'title': 'Test Gadget',
    'description': 'A fantastic test gadget.',
    'imageUrl': 'http://example.com/image.jpg',
    'price': 99.99,
  };

  group('ProductModel from Product Entity', () {
    test('should be a subclass of Product entity', () {
      expect(tProductModel, isA<Product>());
    });

    test('should convert a Product entity to a ProductModel', () {
      final productEntity = Product(
        id: '123',
        title: 'Test Gadget',
        description: 'A fantastic test gadget.',
        imageUrl: 'http://example.com/image.jpg',
        price: 99.99,
      );
      final result = ProductModel.fromEntity(productEntity);
      expect(result, equals(tProductModel));
    });

    test('should convert a ProductModel to a Product entity', () {
      final result = tProductModel.toEntity();
      final expectedEntity = Product(
        id: '123',
        title: 'Test Gadget',
        description: 'A fantastic test gadget.',
        imageUrl: 'http://example.com/image.jpg',
        price: 99.99,
      );
      expect(result, equals(expectedEntity));
      expect(result, isA<Product>());
    });
  });

  group('fromJson', () {
    test('should return a valid ProductModel when the JSON is valid', () {
      // Act
      final result = ProductModel.fromJson(json.decode(json.encode(tProductModelMap))); // simulate decoding from string

      // Assert
      expect(result, equals(tProductModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      // Act
      final result = tProductModel.toJson();

      // Assert
      expect(result, equals(tProductModelMap));
    });
  });

  group('copyWith', () {
    test('should return a new ProductModel with updated values', () {
      final updatedModel = tProductModel.copyWith(
        title: 'Updated Test Gadget',
        price: 100.00,
      );

      expect(updatedModel.id, tProductModel.id); // ID should remain the same
      expect(updatedModel.title, 'Updated Test Gadget');
      expect(updatedModel.price, 100.00);
      expect(updatedModel.description, tProductModel.description);
    });

    test('should return the same ProductModel if no arguments are provided', () {
      final copiedModel = tProductModel.copyWith();
      expect(copiedModel, equals(tProductModel));
    });
  });

  group('Equality and HashCode', () {
    test('should return true for identical instances', () {
      final model1 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      final model2 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      expect(model1 == model2, isTrue);
    });

    test('should return false for different instances', () {
      final model1 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      final model2 = ProductModel(id: 'x', title: 'y', description: 'z', imageUrl: 'w', price: 2.0);
      expect(model1 == model2, isFalse);
    });

    test('should have equal hash codes for equal instances', () {
      final model1 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      final model2 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      expect(model1.hashCode, equals(model2.hashCode));
    });

    test('should have different hash codes for different instances', () {
      final model1 = ProductModel(id: 'a', title: 'b', description: 'c', imageUrl: 'd', price: 1.0);
      final model2 = ProductModel(id: 'x', title: 'y', description: 'z', imageUrl: 'w', price: 2.0);
      expect(model1.hashCode, isNot(equals(model2.hashCode)));
    });
  });
}