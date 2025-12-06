import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

/// Repository для работы с локальными звуками котят
class SoundRepository {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Random _random = Random();

  // Список локальных звуковых файлов
  final List<String> _soundPaths = [
    'sounds/meow1.mp3',
    'sounds/meow2.mp3',
    'sounds/meow3.mp3',
    'sounds/meow4.mp3',
    'sounds/meow5.mp3',
    'sounds/meow6.mp3',
    'sounds/meow7.mp3',
    'sounds/meow8.mp3',
    'sounds/meow9.mp3',
    'sounds/meow10.mp3',
    'sounds/meow12.mp3',
    'sounds/meow13.mp3',
    'sounds/meow14.mp3',
    'sounds/meow15.mp3',
    'sounds/meow16.mp3',
    'sounds/meow11.mp3',
  ];

  SoundRepository() {
    // Настройка плеера для быстрой работы
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
  }

  /// Воспроизвести случайный звук котенка
  Future<void> playRandomMeow() async {
    try {
      // Выбираем случайный звуковой файл
      final soundPath = _soundPaths[_random.nextInt(_soundPaths.length)];

      // Останавливаем предыдущее воспроизведение
      await _audioPlayer.stop();

      // Воспроизводим локальный звук
      await _audioPlayer.play(AssetSource(soundPath));

      // Автоматически останавливаем через 2 секунды
      Future.delayed(const Duration(seconds: 2), () {
        _audioPlayer.stop();
      });

      // print('Playing meow sound: $soundPath');
    } catch (e) {
      print('Error playing meow sound: $e');
    }
  }

  /// Остановить воспроизведение
  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print('Error stopping sound: $e');
    }
  }

  /// Освободить ресурсы
  void dispose() {
    _audioPlayer.dispose();
  }
}