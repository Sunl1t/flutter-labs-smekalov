import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/game_view_model.dart';
import '../widgets/collection_item_card.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({Key? key}) : super(key: key);

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, viewModel, child) {
        final purchasedKittens = viewModel.getPurchasedKittens();
        final purchasedSkins = viewModel.getPurchasedSkins();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Коллекция',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Котята',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              purchasedKittens.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Купите котят в магазине!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: purchasedKittens.length,
                itemBuilder: (context, index) {
                  final kitten = purchasedKittens[index];
                  return GestureDetector(
                    onTap: () {
                      viewModel.activateKitten(kitten.id);
                      _showMessage(
                          context, '${kitten.name} теперь активен!');
                    },
                    child: CollectionItemCard(
                      imagePath: kitten.imagePath,
                      name: kitten.name,
                      isActive: kitten.isActive,
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Скины',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  if (viewModel.state.activeSkinId.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: TextButton(
                        onPressed: () {
                          viewModel.deactivateSkin();
                          _showMessage(context, 'Скин снят!');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.3),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Снять скин'),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              purchasedSkins.isEmpty
                  ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Купите скины в магазине!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemCount: purchasedSkins.length,
                itemBuilder: (context, index) {
                  final skin = purchasedSkins[index];
                  return GestureDetector(
                    onTap: () {
                      viewModel.activateSkin(skin.id);
                      _showMessage(
                          context, 'Скин "${skin.name}" активирован!');
                    },
                    child: CollectionItemCard(
                      imagePath: skin.imagePath,
                      name: skin.name,
                      isActive: skin.isActive,
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

