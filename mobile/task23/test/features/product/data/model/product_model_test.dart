import 'dart:convert';

import 'package:contracts_of_data_sources/features/product/data/models/product_model.dart';
import 'package:contracts_of_data_sources/features/product/domain/entities/product.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tProductModel = ProductModel(
    id: '1',
    imageUrl: 'https://example.com/image.jpg',
    name: 'Test Product',
    price: 19.99,
    description: 'A sample product for testing.',
  );

  test('should be a subclass of Product entity', () {
    expect(tProductModel, isA<Product>());
  });

  test('should return a valid model from JSON', () {
    // arrange
    final jsonMap = json.decode(fixture('product.json'));
    // act
    final result = ProductModel.fromJson(jsonMap);
    // assert
    expect(result, tProductModel);
  });

  test('should return a JSON map containing proper data', () {
    // act
    final result = tProductModel.toJson();
    // assert
    final expectedMap = {
      'id': '1',
      'imageUrl': 'https://example.com/image.jpg',
      'name': 'Test Product',
      'price': 19.99,
      'description': 'A sample product for testing.',
    };
    expect(result, expectedMap);
  });
}
