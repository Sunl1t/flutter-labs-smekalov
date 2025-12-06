import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/game_view_model.dart';
import '../widgets/shop_item_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: viewModel.clicks >= 10
                    ? () {
                  final success = viewModel.exchangeClicksForCoins();
                  if (success) {
                    _showMessage(
                        context, 'Клики успешно обменяны на монетки!');
                  }
                }
                    : null,
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
                child: Text(
                  viewModel.clicks >= 10
                      ? 'Обменять клики (${viewModel.clicks ~/ 10} монет)'
                      : 'Обменять клики (нужно 10)',
                  style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                itemCount: viewModel.skins.length,
                itemBuilder: (context, index) {
                  final skin = viewModel.skins[index];
                  return GestureDetector(
                    onTap: () {
                      if (!skin.isPurchased) {
                        final success = viewModel.purchaseSkin(skin.id);
                        if (success) {
                          viewModel.activateSkin(skin.id);
                          _showMessage(context, 'Скин "${skin.name}" куплен!');
                        } else {
                          _showMessage(context,
                              'Недостаточно монет! Нужно: ${skin.price}');
                        }
                      } else {
                        viewModel.activateSkin(skin.id);
                        _showMessage(context, 'Скин уже куплен!');
                      }
                    },
                    child: ShopItemCard(
                      imagePath: skin.imagePath,
                      name: skin.name,
                      price: skin.price,
                      isPurchased: skin.isPurchased,
                    ),
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
                cacheExtent: 100,
                addAutomaticKeepAlives: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
                ),
                itemCount: viewModel.kittens.where((k) => k.price > 0).length,
                itemBuilder: (context, index) {
                  final kitten = viewModel.kittens
                      .where((k) => k.price > 0)
                      .toList()[index];
                  return GestureDetector(
                    onTap: () {
                      if (!kitten.isPurchased) {
                        final success = viewModel.purchaseKitten(kitten.id);
                        if (success) {
                          _showMessage(
                              context, 'Котенок "${kitten.name}" куплен!');
                          viewModel.activateKitten(kitten.id);
                        } else {
                          _showMessage(context,
                              'Недостаточно монет! Нужно: ${kitten.price}');
                        }
                      } else {
                        viewModel.activateKitten(kitten.id);
                        _showMessage(context, 'Котенок уже куплен!');
                      }
                    },
                    child: ShopItemCard(
                      imagePath: kitten.imagePath,
                      name: kitten.name,
                      price: kitten.price,
                      isPurchased: kitten.isPurchased,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

