import '../../../../core/entities/product.dart'; // Path to Product entity

// Abstract interface that the domain layer interacts with
// This defines the contract for data operations related to Products.
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product?> getProductById(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}