import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductCardItem extends StatelessWidget {
  final BuildContext context;
  final Product product;
  final bool isInDetailPage;
  final void Function(String productName)? onDelete;
  final void Function(Product updatedProduct)? onUpdate;

  const ProductCardItem({
    super.key,
    required this.context,
    required this.product,
    required this.isInDetailPage,
    this.onDelete,
    this.onUpdate,
  });

  void _handleTap() async {
    if (!isInDetailPage) {
      final result = await Navigator.pushNamed(
        context,
        '/details',
        arguments: product,
      );

      if (result != null) {
        if (result is Map && result['action'] == 'delete') {
          onDelete?.call(result['productName']);
        } else if (result is Product) {
          onUpdate?.call(result);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Card(
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(product.imageUrl, fit: BoxFit.fitWidth),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3E3E3E),
                    ),
                  ),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3E3E3E),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.description.split(' ').take(2).join(' '),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.star,
                            color: Color(0xFFFFD700),
                            size: 20,
                          ),
                        ),
                        WidgetSpan(child: SizedBox(width: 4)),
                        TextSpan(
                          text: '(3)',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFAAAAAA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
