import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const KittenClickerApp());
}

class KittenClickerApp extends StatelessWidget {
  const KittenClickerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitten Clicker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFD4A5A5),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

