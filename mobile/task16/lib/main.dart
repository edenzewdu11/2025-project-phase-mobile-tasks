// lib/main.dart

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Core imports
import 'package:contracts_of_data_sources/core/entities/product.dart'; // <--- CORRECTED IMPORT PATH
import 'core/usecases/base_usecase.dart';
import 'core/network/network_info.dart';
import 'core/network/network_info_impl.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';
import 'package:contracts_of_data_sources/core/constants/api_constants.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    final InternetConnection connectionChecker = InternetConnection();

    final NetworkInfo networkInfo = NetworkInfoImpl(connectionChecker);

    final http.Client httpClient = http.Client();
    final ApiService apiService = ApiService(client: httpClient); // <--- NEW: Instantiate ApiService

    // Pass apiService to ProductRemoteDataSourceImpl
    final ProductRemoteDataSource remoteDataSource = ProductRemoteDataSourceImpl(
      apiService: apiService, // <--- CHANGED: Pass apiService
    );
    final ProductLocalDataSource localDataSource = ProductLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
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