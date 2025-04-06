import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'models/product_model.dart';
import 'models/appointment_model.dart';
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/appointment_provider.dart'; // Import AppointmentProvider
import 'pages/intro_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(AppointmentAdapter());

  // Open Hive Boxes
  var usersBox = await Hive.openBox<User>('users');
  await Hive.openBox<Product>('products');
  await Hive.openBox<Appointment>('appointments');

  // Force-create Admin account if not exists
  bool adminExists = usersBox.values.any((user) => user.isAdmin);
  if (!adminExists) {
    usersBox.put("admin", User(
      fullName: "Admin",
      email: "admin@clinic.com",
      password: "admin123",
      isAdmin: true,
    ));
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => AppointmentProvider()),
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
      home: const IntroPage(),
    );
  }
}
