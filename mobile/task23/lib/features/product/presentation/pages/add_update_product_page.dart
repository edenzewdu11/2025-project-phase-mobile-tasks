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
    print('Save button pressed!');
    
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final description = descriptionController.text.trim();
    final imageUrl = imageUrlController.text.trim();

    print('Form data: name="$name", price="$priceText", description="$description", imageUrl="$imageUrl"');

    if (name.isEmpty || priceText.isEmpty || description.isEmpty) {
      print('Validation failed: empty fields');
      _showError('Please fill all fields.');
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      print('Validation failed: invalid price');
      _showError('Enter a valid price.');
      return;
    }

    print('Creating product with price: $price');

    final product = Product(
      id: widget.product?.id ?? '',
      name: name,
      price: price,
      description: description,
      imageUrl: imageUrl.isNotEmpty
          ? imageUrl
          : 'https://via.placeholder.com/150',
    );

    print('Product created: ${product.name} - \$${product.price}');

    if (!widget.isEditing) {
      print('Dispatching CreateProductEvent');
      context.read<ProductBloc>().add(CreateProductEvent(product));
    } else {
      print('Dispatching UpdateProductEvent');
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

  Widget _buildSampleProductChip(String name, String price, String imageUrl) {
    return GestureDetector(
      onTap: () {
        nameController.text = name;
        priceController.text = price;
        imageUrlController.text = imageUrl;
        descriptionController.text = 'Sample description for $name';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF00C853).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF00C853)),
        ),
        child: Text(
          name,
          style: const TextStyle(
            color: Color(0xFF00C853),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
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
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.isEditing ? '✏️ Edit Product' : '➕ Add New Product',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          key: const Key('productFormScrollView'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sample product suggestions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F1F),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF333333)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '💡 Sample Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSampleProductChip('iPhone 15 Pro', '999.99', 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop'),
                        _buildSampleProductChip('Nike Air Max', '150.00', 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=400&fit=crop'),
                        _buildSampleProductChip('Denim Jacket', '89.99', 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?w=400&h=400&fit=crop'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              if (imageUrlController.text.isNotEmpty)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF333333)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrlController.text,
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 160,
                          width: 160,
                          color: const Color(0xFF2A2A2A),
                          child: const Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              buildLabelText('Image URL'),
              buildInputBox(
                key: const Key('imageUrlField'),
                controller: imageUrlController,
                hintText: 'https://images.unsplash.com/...',
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
                          backgroundColor: const Color(0xFF00C853),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
                          backgroundColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(
                            color: Color(0xFF666666),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
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
