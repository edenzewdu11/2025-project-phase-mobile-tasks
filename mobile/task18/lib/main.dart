// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // ADDED

// Core imports
import 'package:contracts_of_data_sources/core/entities/product.dart'; // Ensure this is correct and uncommented
import 'package:contracts_of_data_sources/core/usecases/base_usecase.dart'; // Ensure this is correct and uncommented

// BLoC imports
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart'; // ADDED
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart'; // ADDED
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart'; // ADDED (was missing the actual import line)

// Dependency Injection import
import 'package:contracts_of_data_sources/injection_container.dart' as di; // Alias for clarity

// Presentation screens
import 'package:contracts_of_data_sources/features/product/presentation/screens/detail_page.dart';
import 'package:contracts_of_data_sources/features/product/presentation/screens/edit_page.dart';
import 'package:contracts_of_data_sources/features/product/presentation/screens/home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetIt dependencies before running the app
  await di.init(); // <--- MODIFIED: Call GetIt initialization

  runApp(const MyApp()); // <--- MODIFIED: No longer pass sharedPreferences
}

class MyApp extends StatelessWidget {
  // <--- MODIFIED: Removed sharedPreferences field
  const MyApp({super.key}); // <--- MODIFIED: Removed sharedPreferences from constructor

  @override
  Widget build(BuildContext context) {
    // <--- MODIFIED: All dependencies are now retrieved from GetIt
    // No more manual instantiation of internetConnectionChecker, networkInfo, httpClient, apiService,
    // remoteDataSource, localDataSource, productRepository, or use cases here.

    return BlocProvider( // WRAP WITH BLOCPROVIDER
      // Retrieve ProductBloc instance from GetIt
      create: (context) => di.sl<ProductBloc>()..add(const LoadAllProductsEvent()), // DISPATCH INITIAL EVENT
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
          '/': (context) => const HomeScreen(),
          '/addEdit': (context) => const AddEditProductScreen(),
          '/details': (context) => const ProductDetailScreen(),
        },
      ),
    );
  }
}