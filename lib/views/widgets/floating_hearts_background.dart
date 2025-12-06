import 'dart:math';
import 'package:flutter/material.dart';

class FloatingHeartsBackground extends StatefulWidget {
  final bool isPaused;

  const FloatingHeartsBackground({
    Key? key,
    this.isPaused = false,
  }) : super(key: key);

  @override
  State<FloatingHeartsBackground> createState() => _FloatingHeartsBackgroundState();
}

class _FloatingHeartsBackgroundState extends State<FloatingHeartsBackground>
    with SingleTickerProviderStateMixin {
  final List<_FloatingHeart> _hearts = [];
  final Random _random = Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    // Создаем начальные сердечки по всему экрану
    for (int i = 0; i < 20; i++) {
      _addHeart(randomY: true);
    }

    _controller.addListener(() {
      if (!widget.isPaused) {
        setState(() {
          for (var heart in _hearts) {
            heart.update();
          }

          _hearts.removeWhere((heart) => heart.y < -0.1);

          // Постоянно добавляем новые сердечки
          if (_hearts.length < 20 && _random.nextDouble() < 0.4) {
            _addHeart();
          }
        });
      }
    });
  }

  void _addHeart({bool randomY = false}) {
    final emojis = ['💜', '💕', '💖', '💗', '💓', '🩷', '💝'];

    _hearts.add(_FloatingHeart(
      x: _random.nextDouble(),
      y: randomY
          ? _random.nextDouble() * 1.2
          : 1.0 + _random.nextDouble() * 0.3,
      speed: 0.002 + _random.nextDouble() * 0.004,
      size: 15 + _random.nextDouble() * 20,
      opacity: 0.2 + _random.nextDouble() * 0.4,
      drift: (_random.nextDouble() - 0.5) * 0.0008,
      rotation: _random.nextDouble() * 6.28,
      rotationSpeed: (_random.nextDouble() - 0.5) * 0.02,
      emoji: emojis[_random.nextInt(emojis.length)],
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: IgnorePointer(
        child: Stack(
          children: _hearts.map((heart) {
            return Positioned(
              left: MediaQuery.of(context).size.width * heart.x,
              top: MediaQuery.of(context).size.height * heart.y,
              child: Transform.rotate(
                angle: heart.rotation,
                child: Opacity(
                  opacity: heart.opacity,
                  child: Text(
                    heart.emoji,
                    style: TextStyle(
                      fontSize: heart.size,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.purple.withOpacity(0.3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _FloatingHeart {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;
  final double drift;
  double rotation;
  final double rotationSpeed;
  final String emoji;

  _FloatingHeart({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.drift,
    required this.rotation,
    required this.rotationSpeed,
    required this.emoji,
  });

  void update() {
    y -= speed;
    x += drift;
    rotation += rotationSpeed;

    if (x < -0.1) x = -0.1;
    if (x > 1.1) x = 1.1;
  }
}
