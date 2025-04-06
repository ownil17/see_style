import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/product_provider.dart';
import '/models/product_model.dart';

class ManageProducts extends StatelessWidget {
  const ManageProducts({Key? key}) : super(key: key);

  void _showProductDialog(BuildContext context, {Product? product}) {
    final nameController = TextEditingController(text: product?.name ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final imageUrlController = TextEditingController(text: product?.imageUrl ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? "Add Product" : "Edit Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Product Name")),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: "Price"), keyboardType: TextInputType.number),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: "Description")),
              TextField(controller: imageUrlController, decoration: const InputDecoration(labelText: "Image URL")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final provider = Provider.of<ProductProvider>(context, listen: false);
                final name = nameController.text.trim();
                final priceText = priceController.text.trim();
                final description = descriptionController.text.trim();
                final imageUrl = imageUrlController.text.trim();

                // Validate input
                if (name.isEmpty || priceText.isEmpty || description.isEmpty || imageUrl.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields are required!")),
                  );
                  return;
                }

                final price = double.tryParse(priceText);
                if (price == null || price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Enter a valid price!")),
                  );
                  return;
                }

                // Add or update product
                if (product == null) {
                  provider.addProduct(name, price, description, imageUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product added successfully!")),
                  );
                } else {
                  provider.updateProduct(product.id, name, price, description, imageUrl);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Product updated successfully!")),
                  );
                }

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      appBar: AppBar(title: const Text("Manage Products")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns like home_page.dart
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // Adjust to match home page cards
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => _showProductDialog(context, product: product), // Edit on tap
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                        image: product.imageUrl.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(product.imageUrl),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: product.imageUrl.isEmpty
                          ? const Center(child: Icon(Icons.image, size: 50, color: Colors.grey))
                          : null,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\₱${product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.black),
                                onPressed: () => _showProductDialog(context, product: product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => productProvider.deleteProduct(product.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
