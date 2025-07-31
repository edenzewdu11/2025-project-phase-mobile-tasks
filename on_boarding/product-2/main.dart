import 'dart:io';

class Product {
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  String get name => _name;
  String get description => _description;
  double get price => _price;

  set name(String newName) {
    if (newName.trim().isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    _name = newName;
  }

  set description(String newDescription) {
    _description = newDescription;
  }

  set price(double newPrice) {
    if (newPrice < 0) {
      throw ArgumentError('Price cannot be negative');
    }
    _price = newPrice;
  }

  @override
  String toString() {
    return 'Name: $_name\nDescription: $_description\nPrice: \$$_price';
  }
}

class ProductManager {
  final List<Product> _products = [];

  void addProduct(Product product) {
    _products.add(product);
    print('✅ Product added successfully!\n');
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print('⚠️ No products available.\n');
      return;
    }
    print('📦 All Products:');
    for (var i = 0; i < _products.length; i++) {
      print('\n🆔 ID: $i');
      print(_products[i].toString());
    }
    print('');
  }

  void viewSingleProduct(int id) {
    if (id < 0 || id >= _products.length) {
      print('❌ Product not found.\n');
      return;
    }
    print('\n📌 Product Details (ID: $id)');
    print(_products[id].toString());
    print('');
  }

  void editProduct(int id, {String? newName, String? newDesc, double? newPrice}) {
    if (id < 0 || id >= _products.length) {
      print('❌ Product not found.\n');
      return;
    }
    var p = _products[id];
    try {
      if (newName != null && newName.trim().isNotEmpty) p.name = newName;
      if (newDesc != null) p.description = newDesc;
      if (newPrice != null) p.price = newPrice;
      print('✅ Product updated successfully!\n');
    } catch (e) {
      print('⚠️ Update failed: $e\n');
    }
  }

  void deleteProduct(int id) {
    if (id < 0 || id >= _products.length) {
      print('❌ Product not found.\n');
      return;
    }
    _products.removeAt(id);
    print('✅ Product deleted successfully!\n');
  }
}

void main() {
  var manager = ProductManager();
  while (true) {
    print('========= 🛒 Simple eCommerce CLI =========');
    print('1. Add Product');
    print('2. View All Products');
    print('3. View Single Product');
    print('4. Edit Product');
    print('5. Delete Product');
    print('6. Exit');
    stdout.write('👉 Enter your choice: ');
    var choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter product name: ');
        var name = stdin.readLineSync() ?? '';
        stdout.write('Enter description: ');
        var desc = stdin.readLineSync() ?? '';
        stdout.write('Enter price: ');
        var priceInput = stdin.readLineSync() ?? '0';
        var price = double.tryParse(priceInput) ?? 0;
        try {
          manager.addProduct(Product(name, desc, price));
        } catch (e) {
          print('❌ Error adding product: $e\n');
        }
        break;

      case '2':
        manager.viewAllProducts();
        break;

      case '3':
        stdout.write('Enter product ID: ');
        var idInput = stdin.readLineSync() ?? '0';
        var id = int.tryParse(idInput) ?? -1;
        manager.viewSingleProduct(id);
        break;

      case '4':
        stdout.write('Enter product ID to edit: ');
        var editIdInput = stdin.readLineSync() ?? '0';
        var editId = int.tryParse(editIdInput) ?? -1;
        stdout.write('New name (leave blank to keep): ');
        var newName = stdin.readLineSync();
        stdout.write('New description (leave blank to keep): ');
        var newDesc = stdin.readLineSync();
        stdout.write('New price (leave blank to keep): ');
        var newPriceInput = stdin.readLineSync();
        double? newPrice =
            (newPriceInput != null && newPriceInput.isNotEmpty)
                ? double.tryParse(newPriceInput)
                : null;
        manager.editProduct(editId,
            newName: (newName != null && newName.isNotEmpty) ? newName : null,
            newDesc: (newDesc != null && newDesc.isNotEmpty) ? newDesc : null,
            newPrice: newPrice);
        break;

      case '5':
        stdout.write('Enter product ID to delete: ');
        var delIdInput = stdin.readLineSync() ?? '0';
        var delId = int.tryParse(delIdInput) ?? -1;
        manager.deleteProduct(delId);
        break;

      case '6':
        print('👋 Exiting... Goodbye!');
        return;

      default:
        print('❌ Invalid choice. Please try again.\n');
    }
  }
}
