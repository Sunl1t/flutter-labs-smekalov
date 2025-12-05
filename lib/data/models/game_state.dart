import 'kitten.dart';
import 'skin.dart';

class GameState {
  final int clicks;
  final int coins;
  final List<Kitten> kittens;
  final List<Skin> skins;
  final String activeKittenId;
  final String activeSkinId;

  GameState({
    this.clicks = 0,
    this.coins = 0,
    required this.kittens,
    required this.skins,
    required this.activeKittenId,
    required this.activeSkinId,
  });

  GameState copyWith({
    int? clicks,
    int? coins,
    List<Kitten>? kittens,
    List<Skin>? skins,
    String? activeKittenId,
    String? activeSkinId,
  }) {
    return GameState(
      clicks: clicks ?? this.clicks,
      coins: coins ?? this.coins,
      kittens: kittens ?? this.kittens,
      skins: skins ?? this.skins,
      activeKittenId: activeKittenId ?? this.activeKittenId,
      activeSkinId: activeSkinId ?? this.activeSkinId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clicks': clicks,
      'coins': coins,
      'kittens': kittens.map((k) => k.toJson()).toList(),
      'skins': skins.map((s) => s.toJson()).toList(),
      'activeKittenId': activeKittenId,
      'activeSkinId': activeSkinId,
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      clicks: json['clicks'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      kittens: (json['kittens'] as List<dynamic>?)
          ?.map((k) => Kitten.fromJson(k as Map<String, dynamic>))
          .toList() ??
          [],
      skins: (json['skins'] as List<dynamic>?)
          ?.map((s) => Skin.fromJson(s as Map<String, dynamic>))
          .toList() ??
          [],
      activeKittenId: json['activeKittenId'] as String? ?? '',
      activeSkinId: json['activeSkinId'] as String? ?? '',
    );
  }
}