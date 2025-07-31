import 'package:flutter/material.dart';
import '../models/product.dart';
import '../domain/usecases/delete_product_usecase.dart';
import '../domain/usecases/update_product_usecase.dart'; // Needed for edit navigation

class ProductDetailScreen extends StatelessWidget {
  final DeleteProductUsecase deleteProductUsecase;
  final UpdateProductUsecase updateProductUsecase; // Passed for edit navigation

  const ProductDetailScreen({
    super.key,
    required this.deleteProductUsecase,
    required this.updateProductUsecase, // Receive the update use case
  });

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous screen
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Product product = arguments['product'];
    final int index = arguments['index']; // The index from the list (useful for returning to HomeScreen)

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.green),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey[900]!, Colors.black],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Card
              Card(
                color: Colors.grey[900],
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.green[700]!, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Display
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          product.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[800],
                            child: Icon(Icons.image_not_supported, color: Colors.grey[600], size: 60),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title with icon
                      Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.green[400],
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              product.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Price display
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Description section
                      const Text(
                        'Description',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green[800]!),
                        ),
                        child: Text(
                          product.description,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Details section (static placeholder values for now)
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        'Product ID', // Added Product ID for display
                        product.id,
                        Icons.fingerprint,
                      ),
                      _buildDetailRow(
                        'Created',
                        'Just now', // Placeholder
                        Icons.calendar_today,
                      ),
                      _buildDetailRow(
                        'Status',
                        'In Stock', // Placeholder
                        Icons.inventory_2_outlined,
                      ),
                      _buildDetailRow(
                        'Category',
                        'General', // Placeholder
                        Icons.category_outlined,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Action buttons (Back, Edit, Delete)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    // Back button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context); // Pop back to the previous screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'BACK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Edit button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Navigate to edit screen using pushReplacementNamed.
                          // This means the current detail screen will be removed from the stack.
                          // When /addEdit is done, it will go back to the HomeScreen.
                          final updatedProduct = await Navigator.pushReplacementNamed(
                            context,
                            '/addEdit',
                            arguments: {'product': product, 'index': index}, // Pass current product for editing
                          ) as Product?; // Expect a Product back if it was updated

                          // Note: Since this uses pushReplacementNamed, this StatelessWidget
                          // will be disposed and rebuilt if we return to it, so direct update
                          // of 'product' variable here won't visually update this screen.
                          // The `HomeScreen` will handle the update via its returned value.
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'EDIT',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Delete button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
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
                                      style: TextStyle(
                                        color: Colors.green[400],
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context); // Close dialog
                                      try {
                                        await deleteProductUsecase(product.id);
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product.title} deleted successfully'),
                                              backgroundColor: Colors.red,
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                          // Pop back to HomeScreen and indicate that an item was deleted
                                          Navigator.pop(context, true);
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 20,
                        ),
                        label: const Text(
                          'DELETE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for detail rows
  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green[400], size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
          Expanded( // Use Expanded to prevent overflow for long IDs or text
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis, // Add ellipsis for long text
            ),
          ),
        ],
      ),
    );
  }
}