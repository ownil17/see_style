import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import 'favorite_page.dart';
import 'item_details_page.dart';
import 'schedule_appointment.dart'; // Import Schedule Appointment page

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

    void _onItemTapped(int index) {
      if (index == _selectedIndex) return; // Prevent reloading the same page

      setState(() {
        _selectedIndex = index; // Just update the index, no navigation for Home
      });

      if (index == 1) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const ScheduleAppointment(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child; // No transition effect
            },
          ),
        );
      }
    }



  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final products = productProvider.products;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 44, 52),

      // Drawer for Hamburger Menu
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: const Color.fromARGB(255, 40, 44, 52)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.black),
              title: const Text("Log Out"),
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
            ),
          ],
        ),
      ),

      // Top App Bar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 44, 52),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text(
          "SeeStyle",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
          ),
        ],
      ),

      // Main Body
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            // Featured Frames Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Featured Frames",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Product Grid
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailsPage(
                            itemName: product.name,
                            itemPrice: product.price,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            spreadRadius: 2,
                            offset: const Offset(2, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Container(
                              height: 140,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: product.imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(product.imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                                color: Colors.grey[300],
                              ),
                              child: product.imageUrl.isEmpty
                                  ? const Center(
                                      child: Icon(Icons.image, size: 50, color: Colors.grey),
                                    )
                                  : null,
                            ),
                          ),
                        ),

                          
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₱${product.price.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),

                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today, size: 30), label: "Appointment"),
          BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 30), label: "Order Status"),
          BottomNavigationBarItem(icon: Icon(Icons.person, size: 30), label: "Profile"),
        ],
      ),
    );
  }
}
