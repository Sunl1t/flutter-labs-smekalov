import '../models/game_state.dart';
import '../models/kitten.dart';
import '../models/skin.dart';
import '../services/storage_service.dart';

/// Repository для управления игровым состоянием
class GameRepository {
  final StorageService _storageService;

  GameRepository({StorageService? storageService})
      : _storageService = storageService ?? StorageService();

  /// Загрузить сохраненное состояние игры
  Future<GameState?> loadGameState() async {
    return await _storageService.loadGameState();
  }

  /// Сохранить состояние игры
  Future<void> saveGameState(GameState state) async {
    await _storageService.saveGameState(state);
  }

  /// Создать начальное состояние игры с локальными изображениями
  GameState createInitialGameState() {
    // Стартовый котенок
    final initialKitten = Kitten(
      id: 'kitten_0',
      name: 'Пылинка',
      imagePath: 'assets/images/kittens/kitten_default.jpg',
      price: 0,
      isPurchased: true,
      isActive: true,
    );

    // Котята для магазина
    final kittens = [
      initialKitten,
      Kitten(
        id: 'kitten_1',
        name: 'Милаш',
        imagePath: 'assets/images/kittens/kitten_1.jpg',
        price: 10,
      ),
      Kitten(
        id: 'kitten_2',
        name: 'Лапик',
        imagePath: 'assets/images/kittens/kitten_2.jpg',
        price: 100,
      ),
      Kitten(
        id: 'kitten_3',
        name: 'Брутал',
        imagePath: 'assets/images/kittens/kitten_3.jpg',
        price: 200,
      ),
      Kitten(
        id: 'kitten_4',
        name: 'Рыжулькин',
        imagePath: 'assets/images/kittens/kitten_4.jpg',
        price: 350,
      ),
    ];

    // Скины для магазина
    final skins = [
      Skin(
        id: 'skin_1',
        name: 'Доктор',
        imagePath: 'assets/images/skins/skin_doctor.jpg',
        price: 20,
      ),
      Skin(
        id: 'skin_2',
        name: 'Пожарный',
        imagePath: 'assets/images/skins/skin_fire.png',
        price: 101,
      ),
      Skin(
        id: 'skin_3',
        name: 'Пикачу',
        imagePath: 'assets/images/skins/skin_pikachu.jpg',
        price: 147,
      ),
      Skin(
        id: 'skin_4',
        name: 'Пчелка',
        imagePath: 'assets/images/skins/skin_bee.jpg',
        price: 220,
      ),
      Skin(
        id: 'skin_5',
        name: 'Дракула',
        imagePath: 'assets/images/skins/skin_alucard.jpg',
        price: 666,
      ),
      Skin(
        id: 'skin_6',
        name: 'Горничная',
        imagePath: 'assets/images/skins/skin_gor.jpg',
        price: 2000,
      ),
    ];

    return GameState(
      clicks: 0,
      coins: 0,
      kittens: kittens,
      skins: skins,
      activeKittenId: initialKitten.id,
      activeSkinId: '',
    );
  }

  /// Проверить, есть ли сохраненная игра
  Future<bool> hasSavedGame() async {
    return await _storageService.hasSavedGame();
  }

  /// Очистить сохраненное состояние
  Future<void> clearSavedGame() async {
    await _storageService.clearGameState();
  }
}