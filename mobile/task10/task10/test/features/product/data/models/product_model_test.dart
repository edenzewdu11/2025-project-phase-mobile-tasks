import 'package:flutter_test/flutter_test.dart';
import 'package:task10/core/entities/product.dart'; // Changed 'ecommerce_app' to 'task10'
import 'package:task10/features/product/data/models/product_model.dart'; // Changed 'ecommerce_app' to 'task10'

void main() {
  const tProductModel = ProductModel(
    id: '123',
    title: 'Test Product',
    description: 'A product for testing.',
    imageUrl: 'http://test.com/image.jpg',
    price: 99.99,
  );

  test('should be a subclass of Product entity', () async {
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is valid', () async {
      final Map<String, dynamic> jsonMap = {
        'id': '123',
        'title': 'Test Product',
        'description': 'A product for testing.',
        'imageUrl': 'http://test.com/image.jpg',
        'price': 99.99,
      };
      final result = ProductModel.fromJson(jsonMap);
      expect(result, tProductModel);
    });

    test('should handle integer price from JSON correctly', () async {
      final Map<String, dynamic> jsonMap = {
        'id': '124',
        'title': 'Another Product',
        'description': 'Another product for testing.',
        'imageUrl': 'http://test.com/another.jpg',
        'price': 100,
      };
      final result = ProductModel.fromJson(jsonMap);
      expect(result.price, 100.0);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final expectedJsonMap = {
        'id': '123',
        'title': 'Test Product',
        'description': 'A product for testing.',
        'imageUrl': 'http://test.com/image.jpg',
        'price': 99.99,
      };
      final result = tProductModel.toJson();
      expect(result, expectedJsonMap);
    });
  });

  group('fromEntity', () {
    test('should create a ProductModel from a Product entity', () {
      final Product tProductEntity = Product(
        id: 'entity1',
        title: 'Entity Product',
        description: 'Description from entity.',
        imageUrl: 'http://entity.com/image.png',
        price: 50.0,
      );
      final result = ProductModel.fromEntity(tProductEntity);
      expect(result.id, 'entity1');
      expect(result.title, 'Entity Product');
      expect(result.description, 'Description from entity.');
      expect(result.imageUrl, 'http://entity.com/image.png');
      expect(result.price, 50.0);
      expect(result, isA<ProductModel>());
    });
  });

  group('toEntity', () {
    test('should convert a ProductModel back to a Product entity', () {
      final ProductModel tModel = ProductModel(
        id: 'model1',
        title: 'Model Product',
        description: 'Description from model.',
        imageUrl: 'http://model.com/image.png',
        price: 75.0,
      );
      final result = tModel.toEntity();
      expect(result.id, 'model1');
      expect(result.title, 'Model Product');
      expect(result.description, 'Description from model.');
      expect(result.imageUrl, 'http://model.com/image.png');
      expect(result.price, 75.0);
      expect(result, isA<Product>());
      expect(result, isNot(isA<ProductModel>()));
    });
  });
}