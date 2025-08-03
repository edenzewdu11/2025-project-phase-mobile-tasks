// lib/features/product/presentation/screens/edit_page.dart

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For generating new IDs
import '../../../../core/entities/product.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

class AddEditProductScreen extends StatefulWidget {
  final CreateProductUsecase createProductUsecase;
  final UpdateProductUsecase updateProductUsecase;

  const AddEditProductScreen({
    super.key,
    required this.createProductUsecase,
    required this.updateProductUsecase,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  Product? _editedProduct; // Null if adding new product, contains product if editing

  @override
  void initState() {
    super.initState();
    // Listen for image URL changes to update preview
    _imageUrlController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check if we're editing an existing product
    if (_editedProduct == null) {
      final product = ModalRoute.of(context)?.settings.arguments as Product?;
      if (product != null) {
        _editedProduct = product;
        _titleController.text = _editedProduct!.title;
        _descriptionController.text = _editedProduct!.description;
        _imageUrlController.text = _editedProduct!.imageUrl;
        _priceController.text = _editedProduct!.price.toString();
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    _formKey.currentState?.save();

    final String id = _editedProduct?.id ?? const Uuid().v4(); // Use existing ID or generate new
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final String imageUrl = _imageUrlController.text;
    final double price = double.parse(_priceController.text);

    final productToSave = Product(
      id: id,
      title: title,
      description: description,
      imageUrl: imageUrl,
      price: price,
    );

    try {
      if (_editedProduct == null) {
        // Create new product
        await widget.createProductUsecase(productToSave);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product added successfully!')),
          );
        }
      } else {
        // Update existing product
        await widget.updateProductUsecase(productToSave);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop(true); // Pop with true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save product: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editedProduct != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please provide a title.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a price greater than zero.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long.';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _imageUrlController,
                      decoration: const InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _saveForm(), // Save when done typing URL
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') && !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}