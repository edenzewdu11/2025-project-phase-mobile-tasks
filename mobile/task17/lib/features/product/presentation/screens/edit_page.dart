// lib/features/product/presentation/screens/edit_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import Bloc
import 'package:uuid/uuid.dart';
import 'package:contracts_of_data_sources/core/entities/product.dart';
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_bloc.dart'; // Import ProductBloc
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_event.dart'; // Import ProductEvent
import 'package:contracts_of_data_sources/features/product/domain/bloc/product_state.dart'; // Import ProductState
import 'dart:async'; // For Completer

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({Key? key}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  Product? _editedProduct;
  bool _isSaving = false; // To manage loading state

  @override
  void initState() {
    super.initState();
    _imageUrlController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only fetch arguments once
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

    setState(() {
      _isSaving = true;
    });

    final String id = _editedProduct?.id ?? const Uuid().v4();
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

    // Listen for the ProductOperationSuccess state
    final bloc = context.read<ProductBloc>();
    final completer = Completer<void>(); // Use a completer to wait for state change

    final listener = bloc.stream.listen((state) {
      if (state is ProductOperationSuccess || state is ProductError) {
        completer.complete(); // Complete the future when success or error state is emitted
      }
    });

    try {
      if (_editedProduct == null) {
        bloc.add(CreateProductEvent(productToSave));
      } else {
        bloc.add(UpdateProductEvent(productToSave));
      }
      await completer.future; // Wait for the operation to complete

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
        // Check the final state after the operation
        if (bloc.state is ProductOperationSuccess) {
           Navigator.of(context).pop(true); // Pop and indicate success
        }
      }
    } finally {
      listener.cancel(); // Cancel the listener to prevent memory leaks
      if (mounted) { // Ensure widget is still mounted before setState
        setState(() {
          _isSaving = false;
        });
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
          _isSaving
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveForm,
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
        child: Padding(
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
                        onFieldSubmitted: (_) => _saveForm(),
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
      ),
    );
  }
}