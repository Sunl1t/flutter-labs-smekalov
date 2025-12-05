class Kitten {
  final String id;
  final String name;
  final String imagePath; // Локальный путь к изображению
  final int price;
  final bool isPurchased;
  final bool isActive;

  Kitten({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.price,
    this.isPurchased = false,
    this.isActive = false,
  });

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