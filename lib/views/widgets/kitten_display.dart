import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KittenDisplay extends StatefulWidget {
  final String? imagePath; // Локальный путь (может быть null)
  final String? imageUrl; // URL из API (может быть null)
  final String displayName;
  final VoidCallback onTap;
  final bool isLoadingImage;

  const KittenDisplay({
    Key? key,
    this.imagePath,
    this.imageUrl,
    required this.displayName,
    required this.onTap,
    this.isLoadingImage = false,
  }) : super(key: key);

  @override
  State<KittenDisplay> createState() => _KittenDisplayState();
}

class _KittenDisplayState extends State<KittenDisplay>
    with SingleTickerProviderStateMixin {
  final List<_Heart> _hearts = [];
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    widget.onTap();

    _scaleController.forward().then((_) => _scaleController.reverse());

    setState(() {
      _hearts.add(_Heart(
        position: details.localPosition,
        createdAt: DateTime.now(),
      ));
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          if (_hearts.isNotEmpty) {
            _hearts.removeAt(0);
          }
        });
      }
    });
  }
  Widget _buildImage() {
    // ПРИОРИТЕТ 1: Если есть локальный путь (скин или купленный котенок) - всегда используем его
    if (widget.imagePath != null && widget.imagePath!.isNotEmpty) {
      return Image.asset(
        widget.imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: Icon(
                Icons.pets,
                size: 100,
                color: Colors.grey,
              ),
            ),
          );
        },
      );
    }

    // ПРИОРИТЕТ 2: URL из API - ЗДЕСЬ используем CachedNetworkImage
    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: widget.imageUrl!,
        fit: BoxFit.cover,
        // ДОБАВЬ ЭТИ ПАРАМЕТРЫ для оптимизации:
        memCacheWidth: 300,  // Ограничение размера в оперативной памяти
        memCacheHeight: 300,
        maxWidthDiskCache: 600,  // Ограничение на диске
        maxHeightDiskCache: 600,
        fadeInDuration: const Duration(milliseconds: 300), // Плавное появление
        fadeOutDuration: const Duration(milliseconds: 100),
        placeholder: (context, url) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.purple,
              strokeWidth: 3,
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: Colors.grey[300],
          child: const Icon(
            Icons.pets,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );
    }

    // ПРИОРИТЕТ 3: Если ничего нет - показываем дефолтное изображение
    return Image.asset(
      'assets/images/kittens/kitten_default.jpg',
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(
              Icons.pets,
              size: 100,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _buildImage(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.displayName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.black45,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          ..._hearts.map((heart) {
            final elapsed =
                DateTime.now().difference(heart.createdAt).inMilliseconds;
            final progress = (elapsed / 1000.0).clamp(0.0, 1.0);

            return Positioned(
              left: heart.position.dx - 20,
              top: heart.position.dy - (progress * 100) - 20,
              child: Opacity(
                opacity: 1 - progress,
                child: const Text(
                  '💜',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _Heart {
  final Offset position;
  final DateTime createdAt;

  _Heart({required this.position, required this.createdAt});
}
