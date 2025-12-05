import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service для работы с The Cat API (изображения)
class CatApiService {
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  /// Получить случайное изображение котенка
  Future<String> getRandomCatImage() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/images/search?limit=1&size=small'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['url'] != null) {
          return data[0]['url'] as String;
        }
      }

      // Fallback изображение если API не отвечает
      return 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg';
    } catch (e) {
      print('Error fetching cat image: $e');
      return 'https://cdn2.thecatapi.com/images/0XYvRd7oD.jpg';
    }
  }
}