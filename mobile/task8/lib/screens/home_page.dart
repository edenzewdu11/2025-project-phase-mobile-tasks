import 'package:flutter/material.dart';
import '../models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [];

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
      body: products.isEmpty
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
          : ListView.builder(
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
                    title: Text(
                      product.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      product.description,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                              final updatedProduct = await Navigator.pushNamed(
                                context,
                                '/addEdit',
                                arguments: {'product': product, 'index': index},
                              );

                              if (updatedProduct != null && updatedProduct is Product) {
                                setState(() {
                                  products[index] = updatedProduct;
                                });
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
                                          style: TextStyle(color: Colors.green[400]),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red[900],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            products.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('${product.title} deleted'),
                                              backgroundColor: Colors.red,
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
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
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final shouldDelete = await Navigator.pushNamed(
                        context,
                        '/details',
                        arguments: {'product': product, 'index': index},
                      ) as bool?;

                      if (shouldDelete == true) {
                        if (!mounted) return;
                        setState(() {
                          products.removeAt(index);
                        });
                        if (!mounted) return;
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Product deleted successfully'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newProduct = await Navigator.pushNamed(context, '/addEdit');

          if (mounted && newProduct != null && newProduct is Product) {
            setState(() {
              products.add(newProduct);
            });
          }
        },
        backgroundColor: Colors.green[700],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
