import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/game_view_model.dart';
import '../widgets/counter_display.dart';
import '../widgets/kitten_display.dart';
import '../widgets/floating_hearts_background.dart'; // Добавьте этот импорт
import 'shop_screen.dart';
import 'collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // Главная по центру

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD4A5A5),
      body: SafeArea(
        child: Consumer<GameViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Загрузка звуков котят...',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.error != null) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        viewModel.error!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => viewModel.resetGame(),
                        child: const Text('Попробовать снова'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                CounterDisplay(
                  clicks: viewModel.clicks,
                  coins: viewModel.coins,
                ),
                Expanded(
                  child: Stack(
                    children: [
                      // Фоновая анимация сердечек только на главном экране
                      if (_selectedIndex == 1)
                        const Positioned.fill(
                          child: FloatingHeartsBackground(),
                        ),
                      // Основной контент
                      _buildBody(viewModel),
                    ],
                  ),
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
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(GameViewModel viewModel) {
    switch (_selectedIndex) {
      case 0:
        return const CollectionScreen();
      case 2:
        return const ShopScreen();
      case 1:
      default:
        return Center(
          child: KittenDisplay(
            imagePath: viewModel.getCurrentImagePath(),
            imageUrl: viewModel.currentApiCatImage,
            displayName: viewModel.getCurrentDisplayName(),
            onTap: () => viewModel.incrementClicks(),
            isLoadingImage: viewModel.isLoadingImage,
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

