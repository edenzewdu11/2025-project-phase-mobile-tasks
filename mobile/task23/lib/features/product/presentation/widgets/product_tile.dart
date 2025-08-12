import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final void Function(String productName)? onDelete;
  final void Function(Product updatedProduct)? onUpdate;

  const ProductTile({
    super.key,
    required this.product,
    this.onDelete,
    this.onUpdate,
  });

  void _handleEdit(BuildContext context) async {
    final result = await Navigator.pushNamed<Product>(
      context,
      '/update',
      arguments: product,
    );
    if (result != null && onUpdate != null) {
      onUpdate!(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/details', arguments: product);
      },
      child: Card(
        child: ListTile(
          leading: Image.network(
            product.imageUrl,
            width: 50,
            fit: BoxFit.cover,
          ),
          title: Text(product.name),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _handleEdit(context),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => onDelete?.call(product.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
