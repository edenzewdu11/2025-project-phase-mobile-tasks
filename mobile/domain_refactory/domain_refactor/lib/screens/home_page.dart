import 'package:flutter/material.dart';
import '../models/product.dart';
import '../domain/usecases/view_all_products_usecase.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../domain/usecases/base/usecase.dart'; // For NoParams

class HomeScreen extends StatefulWidget {
  final ViewAllProductsUsecase viewAllProductsUsecase;
  final DeleteProductUsecase deleteProductUsecase;

  const HomeScreen({
    super.key,
    required this.viewAllProductsUsecase,
    required this.deleteProductUsecase,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final loadedProducts = await widget.viewAllProductsUsecase(NoParams());
      setState(() {
        products = loadedProducts;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load products: $e';
        // Show a SnackBar for errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $_errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProduct(Product product, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Delete Product',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to delete "${product.title}"?',
            style: const TextStyle(color: Colors.grey),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: TextStyle(color: Colors.green[400]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[900],
              ),
              onPressed: () async {
                Navigator.pop(context); // Close dialog
                try {
                  await widget.deleteProductUsecase(product.id);
                  if (!mounted) return; // Check if the widget is still in the tree
                  setState(() {
                    products.removeAt(index);
                  });
                  if (context.mounted) { // Check context before showing SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.title} deleted successfully'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete product: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'DELETE',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'My Products',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 80,
                            color: Colors.green[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No products yet!',
                            style: TextStyle(
                              color: Colors.green[200],
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the + button to add your first product',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator( // Added RefreshIndicator for pulling to refresh
                      onRefresh: _loadProducts,
                      color: Colors.green,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: products.length,
                        itemBuilder: (_, index) {
                          final product = products[index];
                          return Card(
                            color: Colors.grey[900],
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: BorderSide(color: Colors.green[700]!, width: 1),
                            ),
                            elevation: 4,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image_not_supported, color: Colors.grey[600]),
                                ),
                              ),
                              title: Text(
                                product.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    product.description,
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                    maxLines: 1, // Changed to 1 line for subtitle
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Edit button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green[900]!.withAlpha((255 * 0.3).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.green[700]!),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit, color: Colors.green[300]),
                                      onPressed: () async {
                                        // Navigate to edit screen and expect a Product back
                                        final result = await Navigator.pushNamed(
                                          context,
                                          '/addEdit',
                                          arguments: {'product': product, 'index': index},
                                        );

                                        // If a Product is returned (meaning it was updated)
                                        if (result != null && result is Product) {
                                          setState(() {
                                            products[index] = result; // Update the item in the list
                                          });
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('${result.title} updated successfully'),
                                                backgroundColor: Colors.green,
                                                duration: const Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Delete button
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red[900]!.withAlpha((255 * 0.3).toInt()),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red[700]!),
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red[300]),
                                      onPressed: () => _deleteProduct(product, index),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                final arguments = {'product': product, 'index': index};
                                // Navigate to details and potentially get a 'true' if deleted
                                final bool? deletedFromDetail = await Navigator.pushNamed(
                                  context,
                                  '/details',
                                  arguments: arguments,
                                ) as bool?;

                                // If product was deleted from the detail page, refresh the list
                                if (deletedFromDetail == true) {
                                  _loadProducts(); // Reload all products after deletion
                                } else {
                                  // If not deleted, and no direct update from detail screen is handled by return value,
                                  // we might still want to refresh if there's a chance something changed.
                                  // For this app, edit from detail page uses pushReplacementNamed,
                                  // so this else block might not be strictly necessary for edits.
                                  // However, a full refresh is always safe.
                                  _loadProducts();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to add screen and expect a new Product back
          final newProduct = await Navigator.pushNamed(context, '/addEdit');

          // If a new Product is returned (meaning it was created)
          if (mounted && newProduct != null && newProduct is Product) {
            // Note: For a real app, _loadProducts() would be better here
            // to fetch the actual state from the repository after creation.
            // For this in-memory example, adding directly to the list is fine
            // if the ID is generated by the repository itself.
            _loadProducts(); // Refresh list to get the product with its assigned ID
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${newProduct.title} added successfully'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}