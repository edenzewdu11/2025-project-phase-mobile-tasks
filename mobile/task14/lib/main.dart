// lib/main.dart

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <--- NEW IMPORT

// Core imports
import 'core/entities/product.dart';
import 'core/usecases/base_usecase.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';

// Feature-specific imports (Product feature)
import 'features/product/data/repositories/product_repository_impl.dart';
import 'features/product/domain/repositories/product_repository.dart';
import 'features/product/domain/usecases/create_product_usecase.dart';
import 'features/product/domain/usecases/delete_product_usecase.dart';
import 'features/product/domain/usecases/view_all_products_usecase.dart';
import 'features/product/domain/usecases/update_product_usecase.dart';

// Data source imports
import 'features/product/data/datasources/product_remote_data_source.dart';
import 'features/product/data/datasources/product_remote_data_source_impl.dart';
import 'features/product/data/datasources/product_local_data_source.dart';
import 'features/product/data/datasources/product_local_data_source_impl.dart';

import 'features/product/presentation/screens/detail_page.dart';
import 'features/product/presentation/screens/edit_page.dart';
import 'features/product/presentation/screens/home_page.dart';


// Make main function async to await SharedPreferences.getInstance()
void main() async { // <--- ADD 'async'
  WidgetsFlutterBinding.ensureInitialized(); // Required for SharedPreferences
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance(); // <--- NEW

  runApp(MyApp(sharedPreferences: sharedPreferences)); // <--- Pass sharedPreferences
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences; // <--- NEW field

  const MyApp({super.key, required this.sharedPreferences}); // <--- NEW constructor

  @override
  Widget build(BuildContext context) {
    // Initialize new infrastructure components first
    final InternetConnectionCheckerPlus internetConnectionChecker =
        InternetConnectionCheckerPlus();

    final NetworkInfo networkInfo = NetworkInfoImpl(internetConnectionChecker);

    final ProductRemoteDataSource remoteDataSource = ProductRemoteDataSourceImpl();
    // Pass sharedPreferences to ProductLocalDataSourceImpl
    final ProductLocalDataSource localDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences, // <--- UPDATED
    );

    // Then initialize the repository with its dependencies
    final ProductRepository productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    // Initialize use cases with the repository
    final ViewAllProductsUsecase viewAllProductsUsecase =
        ViewAllProductsUsecase(productRepository);
    final CreateProductUsecase createProductUsecase =
        CreateProductUsecase(productRepository);
    final UpdateProductUsecase updateProductUsecase =
        UpdateProductUsecase(productRepository);
    final DeleteProductUsecase deleteProductUsecase =
        DeleteProductUsecase(productRepository);


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
              updateProductUsecase: updateProductUsecase,
            ),
      },
    );
  }
}