// lib/main.dart

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart'; // ADDED

// Core imports
import 'package:contracts_of_data_sources/core/entities/product.dart'; // CORRECTED IMPORT PATH
import 'package:contracts_of_data_sources/core/usecases/base_usecase.dart'; // CORRECTED IMPORT PATH
import 'package:contracts_of_data_sources/core/network/network_info.dart';
import 'package:contracts_of_data_sources/core/network/network_info_impl.dart';
import 'package:contracts_of_data_sources/core/services/api_service.dart';
import 'package:contracts_of_data_sources/core/constants/api_constants.dart';
// import 'package:contracts_of_data_sources/core/errors/failures.dart'; // No longer directly needed here

// Feature-specific imports (Product feature)
import 'package:contracts_of_data_sources/features/product/data/repositories/product_repository_impl.dart';
import 'package:contracts_of_data_sources/features/product/domain/repositories/product_repository.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/create_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/delete_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/view_all_products_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/update_product_usecase.dart';
import 'package:contracts_of_data_sources/features/product/domain/usecases/get_single_product_usecase.dart'; // ADDED

// Data source imports
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_remote_data_source_impl.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source.dart';
import 'package:contracts_of_data_sources/features/product/data/datasources/product_local_data_source_impl.dart';

// BLoC imports
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart'; // ADDED
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart'; // ADDED
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart'; // ADDED

import 'package:contracts_of_data_sources/features/product/presentation/screens/detail_page.dart';
import 'package:contracts_of_data_sources/features/product/presentation/screens/edit_page.dart';
import 'package:contracts_of_data_sources/features/product/presentation/screens/home_page.dart';


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
    // Core Infrastructure
    final internetConnectionChecker = InternetConnection();
    final NetworkInfo networkInfo = NetworkInfoImpl(internetConnectionChecker);
    final http.Client httpClient = http.Client();
    final ApiService apiService = ApiService(client: httpClient);

    // Data Sources
    final ProductRemoteDataSource remoteDataSource = ProductRemoteDataSourceImpl(apiService: apiService);
    final ProductLocalDataSource localDataSource = ProductLocalDataSourceImpl(sharedPreferences: sharedPreferences);

    // Repository
    final ProductRepository productRepository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );

    // Use Cases
    final ViewAllProductsUsecase viewAllProductsUsecase = ViewAllProductsUsecase(productRepository);
    final GetSingleProductUsecase getSingleProductUsecase = GetSingleProductUsecase(productRepository); // ADDED
    final CreateProductUsecase createProductUsecase = CreateProductUsecase(productRepository);
    final UpdateProductUsecase updateProductUsecase = UpdateProductUsecase(productRepository);
    final DeleteProductUsecase deleteProductUsecase = DeleteProductUsecase(productRepository);


    return BlocProvider( // WRAP WITH BLOCPROVIDER
      create: (context) => ProductBloc(
        viewAllProductsUsecase: viewAllProductsUsecase,
        getSingleProductUsecase: getSingleProductUsecase, // ADDED
        createProductUsecase: createProductUsecase,
        updateProductUsecase: updateProductUsecase,
        deleteProductUsecase: deleteProductUsecase,
      )..add(const LoadAllProductsEvent()), // DISPATCH INITIAL EVENT
      child: MaterialApp(
        title: 'eCommerce App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(), // MODIFIED: No direct usecase passing
          '/addEdit': (context) => const AddEditProductScreen(), // MODIFIED: No direct usecase passing
          '/details': (context) => const ProductDetailScreen(), // MODIFIED: No direct usecase passing
        },
      ),
    );
  }
}