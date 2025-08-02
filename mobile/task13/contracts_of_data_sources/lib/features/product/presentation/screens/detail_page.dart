// lib/features/product/presentation/screens/detail_page.dart

import 'package:flutter/material.dart';
import '../../../../core/entities/product.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

class ProductDetailScreen extends StatefulWidget {
  final DeleteProductUsecase deleteProductUsecase;
  final UpdateProductUsecase updateProductUsecase;

  const ProductDetailScreen({
    Key? key,
    required this.deleteProductUsecase,
    required this.updateProductUsecase,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product; // Make it nullable

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Retrieve the product passed via route arguments
    _product = ModalRoute.of(context)?.settings.arguments as Product?;
    if (_product == null) {
      // Handle the case where product is not passed, e.g., navigate back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Product details not found.')),
        );
      });
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
      try {
        await widget.deleteProductUsecase(_product!.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product deleted successfully!')),
          );
          Navigator.pop(context, true); // Pop and indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product: $e')),
          );
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
                arguments: _product, // Pass the product for editing
              );
              if (result == true) {
                // If product was updated, a simple way to refresh is to pop and refetch on home screen,
                // or if we had a ViewProductUsecase, fetch updated details.
                // For now, we'll just pop and let the home screen refresh.
                if (mounted) {
                  Navigator.pop(context, true); // Indicate change to previous screen
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteProduct,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
    );
  }
}