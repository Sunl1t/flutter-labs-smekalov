import 'dart:math';
import 'package:flutter/material.dart';

class FloatingHeartsBackground extends StatefulWidget {
  const FloatingHeartsBackground({Key? key}) : super(key: key);

  @override
  State<FloatingHeartsBackground> createState() => _FloatingHeartsBackgroundState();
}

class _FloatingHeartsBackgroundState extends State<FloatingHeartsBackground>
    with TickerProviderStateMixin {
  final List<_FloatingHeart> _hearts = [];
  final Random _random = Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Создаем контроллер анимации
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..repeat();

    // Создаем начальные сердечки
    for (int i = 0; i < 15; i++) {
      _addHeart();
    }

    // Обновляем позиции сердечек
    _controller.addListener(() {
      setState(() {
        for (var heart in _hearts) {
          heart.update();
        }

        // Удаляем сердечки, которые вышли за экран
        _hearts.removeWhere((heart) => heart.y < -50);

        // Добавляем новые сердечки
        if (_hearts.length < 15 && _random.nextDouble() < 0.3) {
          _addHeart();
        }
      });
    });
  }

  void _addHeart() {
    final emojis = ['💜', '💕', '💖', '💗', '💓'];
    _hearts.add(_FloatingHeart(
      x: _random.nextDouble(),
      y: 1.0 + _random.nextDouble() * 0.5, // Начинаем снизу
      speed: 0.003 + _random.nextDouble() * 0.005,
      size: 20 + _random.nextDouble() * 25,
      opacity: 0.3 + _random.nextDouble() * 0.4,
      drift: (_random.nextDouble() - 0.5) * 0.0005,
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
    return Stack(
      children: _hearts.map((heart) {
        return Positioned(
          left: MediaQuery.of(context).size.width * heart.x,
          top: MediaQuery.of(context).size.height * heart.y,
          child: Opacity(
            opacity: heart.opacity,
            child: Text(
              // '💜'
              heart.emoji,
              style: TextStyle(
                fontSize: heart.size,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.purple.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
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
  final String emoji;

  _FloatingHeart({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.drift,
    required this.emoji,
  });

  void update() {
    y -= speed; // Движение вверх
    x += drift; // Небольшое горизонтальное смещение

    // Держим x в пределах экрана
    if (x < -0.1) x = -0.1;
    if (x > 1.1) x = 1.1;
  }
}