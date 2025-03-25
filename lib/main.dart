import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:practice/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'intro_page.dart'; // Import your IntroPage

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the User Adapter
  Hive.registerAdapter(UserAdapter());

  // Open Hive box for users
  await Hive.openBox<User>('users');

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const IntroPage(), // Show IntroPage first
    );
  }
}
