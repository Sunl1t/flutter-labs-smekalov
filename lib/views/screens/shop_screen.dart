import 'package:flutter/material.dart';
import '../models/kitten.dart';
import '../models/skin.dart';
import '../widgets/shop_item_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final skins = [
      Skin(
        id: 'skin_1',
        name: 'Доктор',
        imagePath: 'assets/images/skins/skin_doctor.jpg',
        price: 20,
      ),
      Skin(
        id: 'skin_2',
        name: 'Пикачу',
        imagePath: 'assets/images/skins/skin_pikachu.png',
        price: 147,
      ),
      Skin(
        id: 'skin_3',
        name: 'Дракула',
        imagePath: 'assets/images/skins/skin_dracula.jpg',
        price: 220,
      ),
      Skin(
        id: 'skin_4',
        name: 'Любовь',
        imagePath: 'assets/images/skins/skin_love.jpg',
        price: 666,
      ),
    ];

    final kittens = [
      Kitten(
        id: 'kitten_1',
        name: 'Котенок 1',
        imagePath: 'assets/images/kittens/kitten_1.jpg',
        price: 10,
      ),
      Kitten(
        id: 'kitten_2',
        name: 'Котенок 2',
        imagePath: 'assets/images/kittens/kitten_2.jpg',
        price: 100,
      ),
      Kitten(
        id: 'kitten_3',
        name: 'Котенок 3',
        imagePath: 'assets/images/kittens/kitten_3.jpg',
        price: 200,
      ),
      Kitten(
        id: 'kitten_4',
        name: 'Котенок 4',
        imagePath: 'assets/images/kittens/kitten_4.jpg',
        price: 350,
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: null, // Пока без функционала
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5E6E6),
              foregroundColor: const Color(0xFFFF6B6B),
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Обменять клики (нужно 10)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Скины',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: skins.length,
            itemBuilder: (context, index) {
              final skin = skins[index];
              return ShopItemCard(
                imagePath: skin.imagePath,
                name: skin.name,
                price: skin.price,
              );
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'Котята',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: kittens.length,
            itemBuilder: (context, index) {
              final kitten = kittens[index];
              return ShopItemCard(
                imagePath: kitten.imagePath,
                name: kitten.name,
                price: kitten.price,
              );
            },
          ),
        ],
      ),
    );
  }
}

