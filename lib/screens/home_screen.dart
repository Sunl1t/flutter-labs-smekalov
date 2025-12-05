import 'package:flutter/material.dart';
import '../widgets/counter_display.dart';
import '../widgets/kitten_display.dart';
import 'shop_screen.dart';
import 'collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Главная по центру
  int _clicks = 0;
  int _coins = 0;

  void _incrementClicks() {
    setState(() {
      _clicks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4A5A5),
      body: SafeArea(
        child: Column(
          children: [
            CounterDisplay(
              clicks: _clicks,
              coins: _coins,
            ),
            Expanded(
              child: _buildBody(),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFB88A8A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavButton('Коллекция', 0),
                  _buildNavButton('Главная', 1),
                  _buildNavButton('Магазин', 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const CollectionScreen();
      case 2:
        return const ShopScreen();
      case 1:
      default:
        return Center(
          child: KittenDisplay(
            imagePath: 'assets/images/kittens/kitten_default.png',
            displayName: 'Пылинка',
            onTap: _incrementClicks,
          ),
        );
    }
  }

  Widget _buildNavButton(String label, int index) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF9E7575) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

