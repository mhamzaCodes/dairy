import 'package:cloud_firestore/cloud_firestore.dart';

/// Cattle Model representing an individual animal (Cow/Buffalo) in the farmer's herd.
class CattleModel {
  final String id;
  final String userId;
  final String tagId;
  final String type; // 'Cow' or 'Buffalo'
  final String breed;
  final double averageYield; // Daily Liters
  final String? motherTagId;
  final DateTime? purchaseDate;
  final String? notes;
  final DateTime createdAt;

  const CattleModel({
    required this.id,
    required this.userId,
    required this.tagId,
    required this.type,
    required this.breed,
    this.averageYield = 0.0,
    this.motherTagId,
    this.purchaseDate,
    this.notes,
    required this.createdAt,
  });

  bool get isCow => type.toLowerCase() == 'cow';
  bool get isBuffalo => type.toLowerCase() == 'buffalo';

  factory CattleModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    DateTime? parseNullableDate(dynamic date) {
      if (date == null) return null;
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date);
      return null;
    }

    return CattleModel(
      id: id,
      userId: map['userId'] ?? '',
      tagId: map['tagId'] ?? '',
      type: map['type'] ?? 'Cow',
      breed: map['breed'] ?? '',
      averageYield: (map['averageYield'] as num?)?.toDouble() ?? 0.0,
      motherTagId: map['motherTagId'],
      purchaseDate: parseNullableDate(map['purchaseDate']),
      notes: map['notes'],
      createdAt: parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'tagId': tagId,
      'type': type,
      'breed': breed,
      'averageYield': averageYield,
      'motherTagId': motherTagId,
      'purchaseDate': purchaseDate != null ? Timestamp.fromDate(purchaseDate!) : null,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CattleModel.fromJson(Map<String, dynamic> json) {
    return CattleModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      tagId: json['tagId'] ?? '',
      type: json['type'] ?? 'Cow',
      breed: json['breed'] ?? '',
      averageYield: (json['averageYield'] as num?)?.toDouble() ?? 0.0,
      motherTagId: json['motherTagId'],
      purchaseDate: json['purchaseDate'] != null ? DateTime.parse(json['purchaseDate']) : null,
      notes: json['notes'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tagId': tagId,
      'type': type,
      'breed': breed,
      'averageYield': averageYield,
      'motherTagId': motherTagId,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CattleModel copyWith({
    String? id,
    String? userId,
    String? tagId,
    String? type,
    String? breed,
    double? averageYield,
    String? motherTagId,
    DateTime? purchaseDate,
    String? notes,
    DateTime? createdAt,
  }) {
    return CattleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      tagId: tagId ?? this.tagId,
      type: type ?? this.type,
      breed: breed ?? this.breed,
      averageYield: averageYield ?? this.averageYield,
      motherTagId: motherTagId ?? this.motherTagId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
