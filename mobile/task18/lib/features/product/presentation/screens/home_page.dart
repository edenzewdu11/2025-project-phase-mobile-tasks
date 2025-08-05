// lib/features/product/presentation/screens/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:contracts_of_data_sources/core/entities/product.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart'; // Import ProductBloc
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart'; // Import ProductEvent
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart'; // Import ProductState

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                // If a product was added/edited, reload the list
                context.read<ProductBloc>().add(const LoadAllProductsEvent());
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductBloc>().add(const LoadAllProductsEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<ProductBloc, ProductState>( // Use BlocConsumer for listening and building
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is ProductOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductLoadedAll) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<ProductBloc>().add(const LoadAllProductsEvent());
                // Await the state change to ProductLoadedAll (or Error) to finish refreshing indicator
                await context.read<ProductBloc>().stream.firstWhere((s) => s is ProductLoadedAll || s is ProductError);
              },
              child: ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
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
                          arguments: product, // Pass the product object
                        );
                        if (result == true) {
                          // If deletion/update happened on detail page, refresh
                          context.read<ProductBloc>().add(const LoadAllProductsEvent());
                        }
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is ProductInitial) {
            // If the initial state is still present, trigger a load
            // This ensures products are loaded even if main.dart didn't dispatch it
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProductBloc>().add(const LoadAllProductsEvent());
            });
            return const Center(child: Text('Loading initial products...'));
          } else if (state is ProductError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          // Fallback for unexpected states
          return const Center(child: Text('Unknown state.'));
        },
      ),
    );
  }
}