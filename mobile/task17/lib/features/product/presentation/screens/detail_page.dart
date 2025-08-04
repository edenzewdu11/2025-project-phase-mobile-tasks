// lib/features/product/presentation/screens/detail_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:contracts_of_data_sources/core/entities/product.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart'; // Import ProductBloc
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart'; // Import ProductEvent
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart'; // Import ProductState
import 'dart:async'; // For Completer

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isDeleting = false; // To manage loading state for delete

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch arguments once
    if (_product == null) {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;
      if (product != null) {
        _product = product;
      } else {
        // If product is null, pop back with an error message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Product details not found.')),
          );
        });
      }
    }
  }

  Future<void> _deleteProduct() async {
    if (_product == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${_product!.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _isDeleting = true;
      });

      final bloc = context.read<ProductBloc>();
      final completer = Completer<void>();

      // Listen for the ProductOperationSuccess or ProductError state
      final listener = bloc.stream.listen((state) {
        if (state is ProductOperationSuccess || state is ProductError) {
          completer.complete(); // Complete the future when success or error state is emitted
        }
      });

      try {
        bloc.add(DeleteProductEvent(_product!.id));
        await completer.future; // Wait for the operation to complete

        if (mounted) {
          setState(() {
            _isDeleting = false;
          });
          // Check the final state after the operation
          if (bloc.state is ProductOperationSuccess) {
            Navigator.pop(context, true); // Pop and indicate success to previous screen
          }
        }
      } finally {
        listener.cancel(); // Cancel the listener to prevent memory leaks
        if (mounted) { // Ensure widget is still mounted before setState
          setState(() {
            _isDeleting = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Product not available.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_product!.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.pushNamed(
                context,
                '/addEdit',
                arguments: _product,
              );
              if (result == true) {
                // If product was updated, pop back and let HomeScreen refresh
                if (mounted) {
                  Navigator.pop(context, true);
                }
              }
            },
          ),
          _isDeleting
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: _deleteProduct,
                ),
        ],
      ),
      body: BlocListener<ProductBloc, ProductState>(
        // Listen for error states from the bloc
        listener: (context, state) {
          if (state is ProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_product!.imageUrl.isNotEmpty)
                Center(
                  child: Image.network(
                    _product!.imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                _product!.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '\$${_product!.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.secondary),
              ),
              const SizedBox(height: 15),
              Text(
                _product!.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}