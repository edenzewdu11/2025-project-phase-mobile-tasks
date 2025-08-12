import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';
import '../widgets/product_card.dart'; // ✅ updated widget

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int selectedSize = 41;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetSingleProductEvent(widget.productId));
  }

  void goToUpdatePage(Product product) async {
    final updated = await Navigator.pushNamed(
      context,
      '/update',
      arguments: product,
    );
    if (updated != null && context.mounted) {
      context.read<ProductBloc>().add(GetSingleProductEvent(product.id));
    }
  }

  void _deleteProduct(Product product) {
    context.read<ProductBloc>().add(DeleteProductEvent(product.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocConsumer<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is LoadedAllProductState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/products',
                (_) => false,
              );
            } else if (state is ErrorState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is LoadingState) return const LoadingWidget();
            if (state is ErrorState) {
              return MessageDisplay(message: state.message);
            }
            if (state is LoadedSingleProductState) {
              final product = state.product;

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Use ProductCard with `isInDetailPage: true`
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: ProductCard(
                        product: product,
                        isInDetailPage: true,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Size:',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Color(0xFF3E3E3E),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 60,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            final size = 39 + index;
                            final isSelected = size == selectedSize;

                            return Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    selectedSize = size;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? const Color(0xFF3F51F3)
                                      : Colors.white,
                                  foregroundColor: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text('$size'),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        product.description,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ❌ Delete Button
                          SizedBox(
                            width: 152,
                            child: OutlinedButton(
                              onPressed: () => _deleteProduct(product),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFFFF1313),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Delete',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Color(0xFFFF1313),
                                ),
                              ),
                            ),
                          ),
                          // ✅ Update Button
                          SizedBox(
                            width: 152,
                            child: ElevatedButton(
                              onPressed: () => goToUpdatePage(product),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3F51F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const MessageDisplay(message: 'No product found');
          },
        ),
      ),
    );
  }
}
