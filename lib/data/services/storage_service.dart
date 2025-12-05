import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

/// Service для локального хранения данных
class StorageService {
  static const String _gameStateKey = 'game_state';
  static const String _currentCatImageKey = 'current_cat_image';

  /// Сохранить состояние игры
  Future<void> saveGameState(GameState state) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(state.toJson());
      await prefs.setString(_gameStateKey, jsonString);
      print('Game state saved successfully');
    } catch (e) {
      print('Error saving game state: $e');
      rethrow;
    }
  }

  /// Загрузить состояние игры
  Future<GameState?> loadGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_gameStateKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        print('Game state loaded successfully');
        return GameState.fromJson(jsonMap);
      }

      print('No saved game state found');
      return null;
    } catch (e) {
      print('Error loading game state: $e');
      return null;
    }
  }

  /// Сохранить текущее изображение котенка из API
  Future<void> saveCurrentCatImage(String imageUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentCatImageKey, imageUrl);
      print('Current cat image saved: $imageUrl');
    } catch (e) {
      print('Error saving current cat image: $e');
    }
  }

  /// Загрузить текущее изображение котенка из API
  Future<String?> loadCurrentCatImage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentCatImageKey);
    } catch (e) {
      print('Error loading current cat image: $e');
      return null;
    }
  }

  /// Очистить сохраненные данные
  Future<void> clearGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_gameStateKey);
      await prefs.remove(_currentCatImageKey);
      print('Game state cleared successfully');
    } catch (e) {
      print('Error clearing game state: $e');
      rethrow;
    }
  }

  /// Проверить, есть ли сохраненная игра
  Future<bool> hasSavedGame() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_gameStateKey);
    } catch (e) {
      print('Error checking saved game: $e');
      return false;
    }
  }
}