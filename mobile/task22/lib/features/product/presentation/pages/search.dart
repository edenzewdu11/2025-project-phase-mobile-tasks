import 'package:flutter/material.dart';

import '../widgets/initial_product.dart';
import '../widgets/label_text.dart';
import '../widgets/price_filter_slider.dart';
import '../widgets/product_card_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Center(
          child: Text(
            'Search Product',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        leading: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.only(left: 16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: const Color(0xFF3F51F3),
            onPressed: () {},
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // 1. Input TextField with arrow icon inside
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        suffixIcon: const Icon(
                          Icons.arrow_forward,
                          size: 20,
                          color: Color(0xFF3F51F3),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Blue container with vector icon
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3F51F3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons
                          .filter_list, // Replace with your actual vector icon if available
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Scrollable product list
          Padding(
            padding: const EdgeInsets.only(
              bottom: 338,
            ), // Leave space for bottom panel
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ProductCardList(
                    context: context,
                    products: initialProducts,
                    isInDetailPage:
                        false, // or true if you're inside the detail screen
                  ),
                ],
              ), // Your reusable product list
            ),
          ),

          // Fixed filter container at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 338,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabelText('Category'),
                  const SizedBox(height: 8),
                  // buildInputBox(controller:),
                  const SizedBox(height: 24),
                  buildLabelText('Price Range'),
                  const SizedBox(height: 8),
                  const PriceRangeSlider(),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3F51F3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
