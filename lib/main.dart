import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen/main_screen/main_manager_screen.dart';
import 'screen/manager_screen/product_manager/product_list/actions/add_new_product/add_new_product.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBcRF7x0mYTbTEwm3C_DTEFOPvhqyX7X-c",
      authDomain: "destiny-usa.firebaseapp.com",
      databaseURL: "https://destiny-usa-default-rtdb.firebaseio.com",
      projectId: "destiny-usa",
      storageBucket: "destiny-usa.appspot.com",
      messagingSenderId: "96965763722",
      appId: "1:96965763722:web:42c4668d538f7c1fbb0373",
      measurementId: "G-JKGLHN49V6",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quản lý Destiny USA',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: 'admin/mainscreen',
      routes: {
        'admin/mainscreen': (context) => const main_manager_screen(),
        'admin/addproduct': (context) => const add_new_product(),
      },
    );
  }
}