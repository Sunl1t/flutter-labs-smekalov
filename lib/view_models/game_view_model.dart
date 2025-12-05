import 'package:flutter/material.dart';
import '../data/models/game_state.dart';
import '../data/models/kitten.dart';
import '../data/models/skin.dart';
import '../data/repositories/game_repository.dart';
import '../data/repositories/sound_repository.dart';
import '../data/repositories/cat_repository.dart';

/// ViewModel для управления игровой логикой (MVVM)
class GameViewModel extends ChangeNotifier {
  final GameRepository _gameRepository;
  final SoundRepository _soundRepository;
  final CatRepository _catRepository;
  bool _isLoadingImage = false;

  GameState _state = GameState(
    kittens: [],
    skins: [],
    activeKittenId: '',
    activeSkinId: '',
  );

  bool _isLoading = true;
  String? _error;
  String? _currentApiCatImage; // Текущее изображение из API

  GameViewModel({
    GameRepository? gameRepository,
    SoundRepository? soundRepository,
    CatRepository? catRepository,
  })  : _gameRepository = gameRepository ?? GameRepository(),
        _soundRepository = soundRepository ?? SoundRepository(),
        _catRepository = catRepository ?? CatRepository() {
    _initializeGame();
  }

  // Getters
  GameState get state => _state;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get clicks => _state.clicks;
  int get coins => _state.coins;
  List<Kitten> get kittens => _state.kittens;
  List<Skin> get skins => _state.skins;
  String? get currentApiCatImage => _currentApiCatImage;
  bool get isLoadingImage => _isLoadingImage;

  /// Инициализация игры
  Future<void> _initializeGame() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Загружаем состояние игры
      final savedState = await _gameRepository.loadGameState();

      if (savedState != null && savedState.kittens.isNotEmpty) {
        _state = savedState;
        print('Loaded saved game state');
      } else {
        _state = _gameRepository.createInitialGameState();
        await _saveState();
        print('Created new game state');
      }

      // Загружаем сохраненное изображение из API (если есть)
      _currentApiCatImage = await _catRepository.loadCurrentCatImage();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка инициализации игры: $e';
      _isLoading = false;
      notifyListeners();
      print(_error);
    }
  }

  /// Клик по котенку (с воспроизведением звука и сменой изображения)
  Future<void> incrementClicks() async {
    _state = _state.copyWith(clicks: _state.clicks + 1);
    _saveState();
    notifyListeners();

    // Воспроизводим локальный звук котенка
    await _soundRepository.playRandomMeow();

    // Если активен стандартный котенок (Пылинка) и нет скина - меняем изображение
    final activeKitten = getActiveKitten();
    final activeSkin = getActiveSkin();

    if (activeKitten?.id == 'kitten_0' && activeSkin == null) {
      _isLoadingImage = true;
      // Загружаем новое случайное изображение из API
      try {
        _currentApiCatImage = await _catRepository.fetchRandomCatImage();
        notifyListeners();
      } catch (e) {
        print('Error loading new cat image: $e');
      }
    }
  }

  /// Обмен кликов на монетки (10 кликов = 1 монетка)
  bool exchangeClicksForCoins() {
    if (_state.clicks >= 10) {
      final coinsToAdd = _state.clicks ~/ 10;
      _state = _state.copyWith(
        clicks: _state.clicks % 10,
        coins: _state.coins + coinsToAdd,
      );
      _saveState();
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Покупка котенка
  bool purchaseKitten(String kittenId) {
    final kittenIndex = _state.kittens.indexWhere((k) => k.id == kittenId);
    if (kittenIndex == -1) return false;

    final kitten = _state.kittens[kittenIndex];

    if (kitten.isPurchased || _state.coins < kitten.price) {
      return false;
    }

    final updatedKittens = List<Kitten>.from(_state.kittens);
    updatedKittens[kittenIndex] = kitten.copyWith(isPurchased: true);

    _state = _state.copyWith(
      coins: _state.coins - kitten.price,
      kittens: updatedKittens,
    );

    _saveState();
    notifyListeners();
    return true;
  }

  /// Покупка скина
  bool purchaseSkin(String skinId) {
    final skinIndex = _state.skins.indexWhere((s) => s.id == skinId);
    if (skinIndex == -1) return false;

    final skin = _state.skins[skinIndex];

    if (skin.isPurchased || _state.coins < skin.price) {
      return false;
    }

    final updatedSkins = List<Skin>.from(_state.skins);
    updatedSkins[skinIndex] = skin.copyWith(isPurchased: true);

    _state = _state.copyWith(
      coins: _state.coins - skin.price,
      skins: updatedSkins,
    );

    _saveState();
    notifyListeners();
    return true;
  }

  /// Активировать котенка
  void activateKitten(String kittenId) {
    final kitten = _state.kittens.firstWhere((k) => k.id == kittenId);
    if (!kitten.isPurchased) return;

    final updatedKittens = _state.kittens
        .map((k) => k.copyWith(isActive: k.id == kittenId))
        .toList();

    _state = _state.copyWith(
      kittens: updatedKittens,
      activeKittenId: kittenId,
    );

    // При смене котенка сбрасываем изображение из API
    if (kittenId != 'kitten_0') {
      _currentApiCatImage = null;
    }

    _saveState();
    notifyListeners();
  }

  /// Активировать скин
  void activateSkin(String skinId) {
    final skin = _state.skins.firstWhere((s) => s.id == skinId);
    if (!skin.isPurchased) return;

    final updatedSkins = _state.skins
        .map((s) => s.copyWith(isActive: s.id == skinId))
        .toList();

    _state = _state.copyWith(
      skins: updatedSkins,
      activeSkinId: skinId,
    );
    _currentApiCatImage = null;

    _saveState();
    notifyListeners();
  }

  /// Деактивировать скин
  void deactivateSkin() {
    final updatedSkins = _state.skins
        .map((s) => s.copyWith(isActive: false))
        .toList();

    _state = _state.copyWith(
      skins: updatedSkins,
      activeSkinId: '',
    );

    _saveState();
    notifyListeners();
  }

  /// Получить активного котенка
  Kitten? getActiveKitten() {
    try {
      return _state.kittens.firstWhere((k) => k.id == _state.activeKittenId);
    } catch (e) {
      return null;
    }
  }

  /// Получить активный скин
  Skin? getActiveSkin() {
    if (_state.activeSkinId.isEmpty) return null;
    try {
      return _state.skins.firstWhere((s) => s.id == _state.activeSkinId);
    } catch (e) {
      return null;
    }
  }

  /// Получить текущий путь к изображению или URL
  /// Возвращает null если нужно использовать изображение из API
  String? getCurrentImagePath() {
    // // Если есть активный скин - показываем его
    // final activeSkin = getActiveSkin();
    // if (activeSkin != null) {
    //   return activeSkin.imagePath;
    // }
    //
    // // Если активен стандартный котенок и есть изображение из API - вернем null
    // final activeKitten = getActiveKitten();
    // if (activeKitten?.id == 'kitten_0' && _currentApiCatImage != null) {
    //   return null; // Будем использовать изображение из API
    // }
    //
    // // Иначе возвращаем локальное изображение котенка
    // return activeKitten?.imagePath ?? 'assets/images/kittens/kitten_default.png';
    // ПРИОРИТЕТ 1: Если есть активный скин - ВСЕГДА показываем его
    final activeSkin = getActiveSkin();
    if (activeSkin != null) {
      print('Using skin image: ${activeSkin.imagePath}');
      return activeSkin.imagePath;
    }

    // ПРИОРИТЕТ 2: Если активен любой купленный котенок (не Пылинка) - показываем его
    final activeKitten = getActiveKitten();
    if (activeKitten != null && activeKitten.id != 'kitten_0') {
      print('Using kitten image: ${activeKitten.imagePath}');
      return activeKitten.imagePath;
    }

    // ПРИОРИТЕТ 3: Если активна Пылинка И есть API-картинка - возвращаем null
    // (KittenDisplay покажет API-картинку)
    if (activeKitten?.id == 'kitten_0' && _currentApiCatImage != null) {
      print('Using API image for Пылинка');
      return null;
    }

    // ПРИОРИТЕТ 4: Пылинка без API-картинки - показываем дефолтное изображение
    print('Using default Пылинка image');
    return activeKitten?.imagePath ?? 'assets/images/kittens/kitten_default.jpg';
  }

  /// Получить текущее отображаемое имя
  String getCurrentDisplayName() {
    final activeSkin = getActiveSkin();
    if (activeSkin != null) {
      return activeSkin.name;
    }

    final activeKitten = getActiveKitten();
    return activeKitten?.name ?? 'Котенок';
  }

  /// Получить список купленных котят
  List<Kitten> getPurchasedKittens() {
    return _state.kittens.where((k) => k.isPurchased).toList();
  }

  /// Получить список купленных скинов
  List<Skin> getPurchasedSkins() {
    return _state.skins.where((s) => s.isPurchased).toList();
  }

  /// Сохранить состояние
  Future<void> _saveState() async {
    try {
      await _gameRepository.saveGameState(_state);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  /// Сбросить игру
  Future<void> resetGame() async {
    try {
      await _gameRepository.clearSavedGame();
      _currentApiCatImage = null;
      await _initializeGame();
    } catch (e) {
      _error = 'Ошибка сброса игры: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _soundRepository.dispose();
    super.dispose();
  }
}