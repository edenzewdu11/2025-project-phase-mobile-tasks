import '../../domain/entities/product.dart';

List<Product> initialProducts = [
  const Product(
    id: '1',
    imageUrl: 'images/leather_shoe1.jpeg',
    name: 'Classic Leather Shoe',
    price: 89.99,
    description:
        "Elegant and durable leather shoes perfect for formal occasions or daily wear. Crafted from premium genuine leather, they offer both sophistication and long-lasting performance. The sleek design pairs effortlessly with suits, chinos, or even smart-casual jeans, making them a versatile choice for any wardrobe. A cushioned insole and breathable lining ensure all-day comfort, whether you're in the office or out for a night on the town.",
  ),
  const Product(
    id: '2',
    imageUrl: 'images/tshirt_men1.jpeg',
    name: 'Slim Fit T-Shirt',
    price: 29.99,
    description:
        'Comfortable slim fit t-shirt made from high-quality cotton, great for everyday style.',
  ),
  const Product(
    id: '3',
    imageUrl: 'images/phone1.jpeg',
    name: 'Smartphone X12',
    price: 699.00,
    description:
        'Powerful smartphone with a stunning display, long battery life, and top-tier camera.',
  ),
  const Product(
    id: '4',
    imageUrl: 'images/sofa1.jpg',
    name: 'Cozy Sofa',
    price: 449.50,
    description:
        'Modern and comfortable sofa designed to add elegance and relaxation to any living room.',
  ),
];
