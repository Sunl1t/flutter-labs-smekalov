class Kitten {
  final String id;
  final String name;
  final String imagePath;
  final int price;
  final bool isPurchased;
  final bool isActive;
  /// Конструктор класса
  Kitten({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.isPurchased = false,
    this.isActive = false,
  });
  /// Создание нового объекта на основе текущего
  Kitten copyWith({
    String? id,
    String? name,
    String? imagePath,
    int? price,
    bool? isPurchased,
    bool? isActive,
  }) {
    return Kitten(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      isPurchased: isPurchased ?? this.isPurchased,
      isActive: isActive ?? this.isActive,
    );
  }
  /// Преобразование в объект
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'price': price,
      'isPurchased': isPurchased,
      'isActive': isActive,
    };
  }
  /// Фабричный конструктор
  factory Kitten.fromJson(Map<String, dynamic> json) {
    return Kitten(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      price: json['price'] as int,
      isPurchased: json['isPurchased'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}