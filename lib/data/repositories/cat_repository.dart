import '../services/cat_api_service.dart';
import '../services/storage_service.dart';

/// Repository для работы с изображениями котят из API
class CatRepository {
  final CatApiService _apiService;
  final StorageService _storageService;

  CatRepository({
    CatApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? CatApiService(),
        _storageService = storageService ?? StorageService();

  /// Получить новое случайное изображение котенка
  Future<String> fetchRandomCatImage() async {
    final imageUrl = await _apiService.getRandomCatImage();
    await _storageService.saveCurrentCatImage(imageUrl);
    return imageUrl;
  }

  /// Загрузить текущее изображение котенка
  Future<String?> loadCurrentCatImage() async {
    return await _storageService.loadCurrentCatImage();
  }
}