import 'package:contracts_of_data_sources/core/errors/exceptions.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';
import '../models/product_model.dart';
import 'product_remote_data_source.dart';

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<ProductModel>> getAllProductModels() async {
    try {
      // Define 5 sample English products
      final List<Map<String, dynamic>> sampleProducts = [
        {
          'id': '1',
          'title': 'Wireless Headphones',
          'description': 'High-quality wireless headphones with noise cancellation and 30-hour battery life.',
          'imageUrl': 'https://picsum.photos/200/300?random=1',
          'price': 129.99,
        },
        {
          'id': '2',
          'title': 'Smartphone X',
          'description': 'Latest smartphone with 6.5" display, 128GB storage, and triple camera system.',
          'imageUrl': 'https://picsum.photos/200/300?random=2',
          'price': 699.99,
        },
        {
          'id': '3',
          'title': 'Laptop Pro',
          'description': 'Powerful laptop with 16GB RAM, 1TB SSD, and dedicated graphics.',
          'imageUrl': 'https://picsum.photos/200/300?random=3',
          'price': 1299.99,
        },
        {
          'id': '4',
          'title': 'Smart Watch',
          'description': 'Fitness tracker with heart rate monitor, GPS, and 7-day battery life.',
          'imageUrl': 'https://picsum.photos/200/300?random=4',
          'price': 199.99,
        },
        {
          'id': '5',
          'title': 'Bluetooth Speaker',
          'description': 'Portable waterproof speaker with 20-hour playtime and deep bass.',
          'imageUrl': 'https://picsum.photos/200/300?random=5',
          'price': 79.99,
        },
      ];
      
      // Convert the sample products to ProductModel objects
      return sampleProducts.map((product) => ProductModel(
        id: product['id'],
        title: product['title'],
        description: product['description'],
        imageUrl: product['imageUrl'],
        price: (product['price'] as num).toDouble(),
      )).toList();
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to load products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel?> getProductModelById(String id) async {
    try {
      // Get all products and find the one with matching ID
      final products = await getAllProductModels();
      return products.firstWhere(
        (product) => product.id == id,
        orElse: () => throw ServerException('Product not found'),
      );
    } on StateError {
      // Thrown by firstWhere when no product is found
      return null;
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to load product: ${e.toString()}');
    }
  }

  @override
  Future<void> createProductModel(ProductModel product) async {
    try {
      // JSONPlaceholder doesn't actually save the data, but will respond with a success
      await apiService.post(
        '/posts',
        {
          'title': product.title,
          'body': product.description,
          // Note: JSONPlaceholder will ignore these fields and return a mock response
          'id': product.id,
          'price': product.price,
        },
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<void> updateProductModel(ProductModel product) async {
    try {
      // JSONPlaceholder doesn't actually update the data, but will respond with a success
      await apiService.put(
        '/posts/${product.id}',
        {
          'id': int.tryParse(product.id) ?? 1, // Ensure ID is an int for the API
          'title': product.title,
          'body': product.description,
          // Note: JSONPlaceholder will ignore these fields and return a mock response
          'price': product.price,
        },
      );
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProductModel(String id) async {
    try {
      // JSONPlaceholder doesn't actually delete the data, but will respond with a success
      await apiService.delete('/posts/$id');
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw ServerException('Failed to delete product: ${e.toString()}');
    }
  }
}