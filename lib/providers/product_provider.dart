import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductProvider extends ChangeNotifier {
  final Box<Product> _productBox = Hive.box<Product>('products');
  
  List<Product> get products => _productBox.values.toList();

  void addProduct(String name, double price, String description, String imageUrl) {
    final newProduct = Product(
      id: const Uuid().v4(), 
      name: name,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    _productBox.put(newProduct.id, newProduct);
    notifyListeners(); // Ensure UI updates
  }

  void updateProduct(String id, String name, double price, String description, String imageUrl) {
    final updatedProduct = Product(
      id: id,
      name: name,
      price: price,
      description: description,
      imageUrl: imageUrl,
    );
    _productBox.put(id, updatedProduct);
    notifyListeners(); // Ensure UI updates
  }

  void deleteProduct(String id) {
    _productBox.delete(id);
    notifyListeners(); // Ensure UI updates
  }
}
