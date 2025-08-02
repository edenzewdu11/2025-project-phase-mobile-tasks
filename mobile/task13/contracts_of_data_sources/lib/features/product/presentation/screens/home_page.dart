// lib/features/product/presentation/screens/home_page.dart

import 'package:flutter/material.dart';
import '../../../../core/entities/product.dart';
import '../../../../core/usecases/base_usecase.dart'; // For NoParams
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/view_all_products_usecase.dart';

class HomeScreen extends StatefulWidget {
  final ViewAllProductsUsecase viewAllProductsUsecase;
  final DeleteProductUsecase deleteProductUsecase; // Passed but not directly used on list view items

  const HomeScreen({
    Key? key,
    required this.viewAllProductsUsecase,
    required this.deleteProductUsecase,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    setState(() {
      _productsFuture = widget.viewAllProductsUsecase(NoParams());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.pushNamed(context, '/addEdit');
              if (result == true) {
                _fetchProducts(); // Refresh list if product was added/edited
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchProducts,
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                _fetchProducts();
                await _productsFuture; // Wait for future to complete
              },
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: product.imageUrl.isNotEmpty
                            ? NetworkImage(product.imageUrl)
                            : null,
                        child: product.imageUrl.isEmpty
                            ? const Icon(Icons.image)
                            : null,
                      ),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: product,
                        );
                        if (result == true) {
                          _fetchProducts(); // Refresh if product was deleted/updated
                        }
                      },
                      // You can add trailing actions if needed, e.g., edit/delete from list
                      // trailing: IconButton(
                      //   icon: const Icon(Icons.delete),
                      //   onPressed: () async {
                      //     // Implement delete logic directly or navigate to detail to delete
                      //     await widget.deleteProductUsecase(product.id);
                      //     _fetchProducts(); // Refresh list after deletion
                      //   },
                      // ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}