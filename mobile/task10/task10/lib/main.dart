// lib/main.dart

import 'package:flutter/material.dart';

// Core imports
import 'core/entities/product.dart';
import 'core/usecases/base_usecase.dart';

// Feature-specific imports (Product feature)
import 'features/product/data/repositories/product_repository_impl.dart'; // <--- Check this import
import 'features/product/domain/repositories/product_repository.dart'; // <--- Check this import
import 'features/product/domain/usecases/create_product_usecase.dart';
import 'features/product/domain/usecases/delete_product_usecase.dart';
import 'features/product/domain/usecases/view_all_products_usecase.dart';
import 'features/product/domain/usecases/update_product_usecase.dart';
// import 'features/product/domain/usecases/view_product_usecase.dart'; // Only if you explicitly use it here

import 'features/product/presentation/screens/detail_page.dart';
import 'features/product/presentation/screens/edit_page.dart';
import 'features/product/presentation/screens/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the repository and use cases here
    // In a real app, you might use a dependency injection package (like GetIt, Provider)
    // to manage these instances throughout the app.
    final ProductRepository productRepository = ProductRepositoryImpl(); // This line
    final ViewAllProductsUsecase viewAllProductsUsecase =
        ViewAllProductsUsecase(productRepository);
    final CreateProductUsecase createProductUsecase =
        CreateProductUsecase(productRepository);
    final UpdateProductUsecase updateProductUsecase =
        UpdateProductUsecase(productRepository);
    final DeleteProductUsecase deleteProductUsecase =
        DeleteProductUsecase(productRepository);
    // ViewProductUsecase (used if you fetch a single product by ID, e.g., on detail page load)
    // final ViewProductUsecase viewProductUsecase = ViewProductUsecase(productRepository);


    return MaterialApp(
      title: 'eCommerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(
              viewAllProductsUsecase: viewAllProductsUsecase,
              deleteProductUsecase: deleteProductUsecase,
            ),
        // For /addEdit route, we pass both create and update use cases
        '/addEdit': (context) => AddEditProductScreen(
              createProductUsecase: createProductUsecase,
              updateProductUsecase: updateProductUsecase,
            ),
        // For /details route, we pass delete and update use cases
        '/details': (context) => ProductDetailScreen(
              deleteProductUsecase: deleteProductUsecase,
              updateProductUsecase: updateProductUsecase,
            ),
      },
    );
  }
}