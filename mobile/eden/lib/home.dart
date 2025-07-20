import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'details.dart';
import 'searchpage.dart';
import 'update.dart';

// Sample product data
class Product {
  final String id;
  final String name;
  final String price;
  final String category;
  final double rating;
  final String imageUrl;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.description,
  });
}

// Sample product list
final List<Product> products = [
  Product(
    id: '1',
    name: 'Nike Air Max',
    price: '\$129.99',
    category: 'Running Shoes',
    rating: 4.5,
    imageUrl: 'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/skwgyqrbfzhu6uyeh0gg/air-max-270-mens-shoes-KkLcCS.png',
    description: 'The Nike Air Max 270 is a lifestyle shoe that delivers style, comfort and big attitude.',
  ),
  Product(
    id: '2',
    name: 'Adidas Ultraboost',
    price: '\$179.99',
    category: 'Running Shoes',
    rating: 4.7,
    imageUrl: 'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/2ce19e89d14f401b90a1af2d00e5df5d_9366/Ultraboost_23_Shoes_Black_HP9201_01_standard.jpg',
    description: 'The Ultraboost 23 is the most responsive Ultraboost yet, with our most advanced cushioning system.',
  ),
  Product(
    id: '3',
    name: 'Puma RS-X',
    price: '\$109.99',
    category: 'Lifestyle',
    rating: 4.3,
    imageUrl: 'https://pumaimages.azureedge.net/images/306152/01/sv01/fnd/EEA/w/1000/h/1000/bg/255,255,255',
    description: 'The RS-X is a retro-inspired sneaker with a chunky silhouette and bold color blocking.',
  ),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('July 14, 2023', style: TextStyle(color: Colors.grey)),
                      Text('Hello, Yohannes', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      // Handle refresh
                    },
                  ),
                ],
              ),
            ),
            // Available Products Header with Search Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // Navigate to Search Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Product List
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    productName: product.name,
                    price: product.price,
                    category: product.category,
                    rating: product.rating,
                    imageUrl: product.imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(product: product),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddUpdatePage(product: product),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add/Update Page for adding
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUpdatePage()),
          );
        },
        backgroundColor: Colors.blue[700],
        child: Icon(Icons.add),
      ),
    );
  }
}

// Custom Product Card Widget (example)
class ProductCard extends StatelessWidget {
  final String productName;
  final String price;
  final String category;
  final double rating;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const ProductCard({
    super.key,
    required this.productName,
    required this.price,
    required this.category,
    required this.rating,
    required this.imageUrl,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: onEdit,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.blue.withOpacity(0.8),
                        padding: const EdgeInsets.all(6),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                productName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category, style: TextStyle(color: Colors.grey)),
                  Text(price, style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 18),
                  Text('(${rating.toStringAsFixed(1)})'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}