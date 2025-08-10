// lib/features/product/presentation/pages/retrieve_all_products_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/product_card.dart';

class RetrieveAllProductsPage extends StatelessWidget {
  const RetrieveAllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProductBloc>().add(const LoadAllProductEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const LoadingWidget();
          } else if (state is LoadedAllProductState) {
            if (state.products.isEmpty) {
              return const Center(child: Text('No products found.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return ProductCard(product: product);
              },
            );
          } else if (state is ErrorState) {
            return MessageDisplay(message: state.message);
          }

          return const MessageDisplay(message: 'Start by loading products');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
