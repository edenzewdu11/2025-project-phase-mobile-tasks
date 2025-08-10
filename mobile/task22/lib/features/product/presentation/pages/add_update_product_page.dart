import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/input_box.dart';
import '../widgets/label_text.dart';
import '../widgets/loading_widget.dart';

class AddUpdateProductPage extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  const AddUpdateProductPage({
    super.key,
    this.product,
    required this.isEditing,
  });

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  late final TextEditingController nameController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;
  late final TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final description = descriptionController.text.trim();
    final imageUrl = imageUrlController.text.trim();

    if (name.isEmpty || priceText.isEmpty || description.isEmpty) {
      _showError('Please fill all fields.');
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      _showError('Enter a valid price.');
      return;
    }

    final product = Product(
      id: widget.product?.id ?? '',
      name: name,
      price: price,
      description: description,
      imageUrl: imageUrl.isNotEmpty
          ? imageUrl
          : 'https://via.placeholder.com/150',
    );

    if (!widget.isEditing) {
      context.read<ProductBloc>().add(CreateProductEvent(product));
    } else {
      context.read<ProductBloc>().add(UpdateProductEvent(product));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearForm() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();
    imageUrlController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is LoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) =>
                const LoadingWidget(), // ✅ Use your widget inside a dialog
          );
        } else if (state is ErrorState) {
          _showError(state.message);
        } else if (state is LoadedAllProductState && !widget.isEditing) {
          // Created successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product created successfully!')),
          );
        } else if (state is LoadedSingleProductState && widget.isEditing) {
          // Updated successfully
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully!')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
        ),
        body: SingleChildScrollView(
          key: const Key('productFormScrollView'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrlController.text.isNotEmpty)
                Center(
                  child: Image.network(
                    imageUrlController.text,
                    height: 160,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              const SizedBox(height: 16),
              buildLabelText('Image URL'),
              buildInputBox(
                key: const Key('imageUrlField'), // Add this key
                controller: imageUrlController,
                hintText: 'https://...',
              ),

              const SizedBox(height: 16),
              buildLabelText('Name'),
              buildInputBox(
                key: const Key('nameField'),
                controller: nameController,
              ),
              const SizedBox(height: 16),
              buildLabelText('Price'),
              buildInputBox(
                key: const Key('priceField'),
                controller: priceController,
                keyboardType: TextInputType.number,
                suffixIcon: const Icon(Icons.attach_money),
              ),
              const SizedBox(height: 16),
              buildLabelText('Description'),
              buildInputBox(
                key: const Key('descriptionField'),
                controller: descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  final isLoading = state is LoadingState;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        key: const Key('addUpdatButton'),
                        onPressed: isLoading ? null : _onSavePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51F3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            // 👈 Border radius
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          widget.isEditing ? 'Update' : 'Add',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: isLoading ? null : _clearForm,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            // 👈 Border color and width
                            color: Color(0xFFFF1313), // Red border
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            // 👈 Border radius
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF1313),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
