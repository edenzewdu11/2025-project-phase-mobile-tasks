import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'home.dart'; // Import the Product class

class AddUpdatePage extends StatefulWidget {
  final Product? product; // Null means we're adding a new product
  
  const AddUpdatePage({
    super.key, 
    this.product,
  });

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  String? _imageUrl;
  String? _selectedCategory;
  final List<String> _categories = ['Running Shoes', 'Lifestyle', 'Basketball', 'Football', 'Casual', 'Formal'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.replaceAll(r'$', '') ?? ''
    );
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _imageUrl = widget.product?.imageUrl;
    _selectedCategory = widget.product?.category;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would save this to a database or API
      final product = Product(
        id: widget.product?.id ?? DateTime.now().toString(),
        name: _nameController.text,
        price: '\$${_priceController.text}',
        category: _selectedCategory ?? _categories.first,
        rating: widget.product?.rating ?? 4.0, // Default rating for new products
        imageUrl: _imageUrl ?? 'https://via.placeholder.com/300',
        description: _descriptionController.text,
      );

      // Navigate back with the updated/created product
      Navigator.pop(context, product);
    }
  }

  // For future implementation of image picking
  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     // In a real app, you would upload the image to a server
  //     setState(() {
  //       _imageUrl = image.path; // This would be the uploaded URL in a real app
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product != null ? 'Update Product' : 'Add New Product'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image preview/upload
              GestureDetector(
                // onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text('Tap to add image'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Product Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a product name' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((String category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              
              const SizedBox(height: 16),
              
              // Price
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) => value?.isEmpty ?? true ? 'Please enter a description' : null,
              ),
              
              const SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  widget.product != null ? 'UPDATE PRODUCT' : 'ADD PRODUCT',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              
              // Delete Button (only for editing existing product)
              if (widget.product != null) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle delete product
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Product'),
                          content: const Text('Are you sure you want to delete this product?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true); // Return true to indicate delete
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('DELETE'),
                            ),
                          ],
                        ),
                      ).then((shouldDelete) {
                        if (shouldDelete == true) {
                          // In a real app, you would delete the product here
                          Navigator.pop(context, null); // Return null to indicate deletion
                        }
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'DELETE PRODUCT',
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}