// lib/core/data/sample_products.dart

import '../../features/product/data/models/product_model.dart';

class SampleProducts {
  // Sample product data in English
  static List<ProductModel> get sampleProducts => [
        ProductModel(
          id: '1',
          title: 'Wireless Bluetooth Headphones',
          description: 'High-quality wireless headphones with noise cancellation and 30-hour battery life.',
          imageUrl: 'https://example.com/images/headphones.jpg',
          price: 129.99,
        ),
        ProductModel(
          id: '2',
          title: 'Smartphone X',
          description: 'Latest smartphone with 6.5" AMOLED display and triple camera setup.',
          imageUrl: 'https://example.com/images/smartphone.jpg',
          price: 799.99,
        ),
        ProductModel(
          id: '3',
          title: 'Laptop Pro',
          description: 'Powerful laptop with 16GB RAM, 1TB SSD, and dedicated graphics card.',
          imageUrl: 'https://example.com/images/laptop.jpg',
          price: 1299.99,
        ),
        ProductModel(
          id: '4',
          title: 'Smart Watch Series 5',
          description: 'Feature-rich smartwatch with heart rate monitoring and GPS.',
          imageUrl: 'https://example.com/images/smartwatch.jpg',
          price: 249.99,
        ),
        ProductModel(
          id: '5',
          title: 'Wireless Earbuds Pro',
          description: 'True wireless earbuds with active noise cancellation and 24h battery life.',
          imageUrl: 'https://example.com/images/earbuds.jpg',
          price: 179.99,
        ),
      ];
}
