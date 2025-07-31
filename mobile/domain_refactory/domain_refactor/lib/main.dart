import 'package:flutter/material.dart';

import './data/repositories/product_repository.dart'; // Import the concrete repository
import 'domain/repositories/product_repository.dart';    // Import the abstract repository
import 'domain/usecases/create_product_usecase.dart';
import 'domain/usecases/delete_product_usecase.dart';
import 'domain/usecases/view_all_products_usecase.dart';
import 'domain/usecases/view_product_usecase.dart'; // Not directly used in routes, but good to have
import 'domain/usecases/update_product_usecase.dart';
import './domain/usecases/base/usecase.dart'; // For NoParams

import 'screens/detail_page.dart';
import 'screens/edit_page.dart'; // Renamed from add_edit_product_screen.dart
import 'screens/home_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the repository and use cases here
    // In a larger app, you'd use a proper Dependency Injection (DI) framework like GetIt or Riverpod.
    final ProductRepository productRepository = ProductRepositoryImpl();
    final ViewAllProductsUsecase viewAllProductsUsecase =
        ViewAllProductsUsecase(productRepository);
    final CreateProductUsecase createProductUsecase =
        CreateProductUsecase(productRepository);
    final UpdateProductUsecase updateProductUsecase =
        UpdateProductUsecase(productRepository);
    final DeleteProductUsecase deleteProductUsecase =
        DeleteProductUsecase(productRepository);
    // ViewProductUsecase is typically used internally by a screen that needs to
    // fetch a product by ID (e.g., if navigating to a detail page with only an ID),
    // rather than being passed directly via route arguments like this.

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
        '/addEdit': (context) => AddEditProductScreen(
              createProductUsecase: createProductUsecase,
              updateProductUsecase: updateProductUsecase,
            ),
        '/details': (context) => ProductDetailScreen(
              deleteProductUsecase: deleteProductUsecase,
              updateProductUsecase: updateProductUsecase, // Needed for edit navigation from details
            ),
      },
    );
  }
}