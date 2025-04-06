import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.cartItems;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Favorites"),
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("You do not have a favorite yet"))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(item.name),
                    subtitle: Text("\₱${(item.price * item.quantity).toStringAsFixed(2)}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            cartProvider.decreaseQuantity(item.name);
                          },
                        ),
                        Text("${item.quantity}"),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            cartProvider.increaseQuantity(item.name);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            cartProvider.removeFromCart(item.name);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
