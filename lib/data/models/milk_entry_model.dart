import 'package:cloud_firestore/cloud_firestore.dart';

class MilkEntryModel {
  final String id;
  final String userId;
  final DateTime date;
  final String shift; // 'Morning' or 'Evening'
  final double quantityLiters;
  final double fatPercentage;
  final double pricePerLiter;
  final double totalRevenue;
  final String? notes;
  final DateTime createdAt;

  MilkEntryModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.shift,
    required this.quantityLiters,
    this.fatPercentage = 0.0,
    required this.pricePerLiter,
    double? totalRevenue,
    this.notes,
    DateTime? createdAt,
  })  : totalRevenue = totalRevenue ?? (quantityLiters * pricePerLiter),
        createdAt = createdAt ?? DateTime.now();

  factory MilkEntryModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    final quantity = (map['quantityLiters'] as num?)?.toDouble() ?? 0.0;
    final price = (map['pricePerLiter'] as num?)?.toDouble() ?? 0.0;
    final revenue = (map['totalRevenue'] as num?)?.toDouble() ?? (quantity * price);

    return MilkEntryModel(
      id: id,
      userId: map['userId'] ?? '',
      date: parseDate(map['date']),
      shift: map['shift'] ?? 'Morning',
      quantityLiters: quantity,
      fatPercentage: (map['fatPercentage'] as num?)?.toDouble() ?? 0.0,
      pricePerLiter: price,
      totalRevenue: revenue,
      notes: map['notes'],
      createdAt: parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'shift': shift,
      'quantityLiters': quantityLiters,
      'fatPercentage': fatPercentage,
      'pricePerLiter': pricePerLiter,
      'totalRevenue': totalRevenue,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MilkEntryModel.fromJson(Map<String, dynamic> json) {
    final quantity = (json['quantityLiters'] as num?)?.toDouble() ?? 0.0;
    final price = (json['pricePerLiter'] as num?)?.toDouble() ?? 0.0;

    return MilkEntryModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      shift: json['shift'] ?? 'Morning',
      quantityLiters: quantity,
      fatPercentage: (json['fatPercentage'] as num?)?.toDouble() ?? 0.0,
      pricePerLiter: price,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? (quantity * price),
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'shift': shift,
      'quantityLiters': quantityLiters,
      'fatPercentage': fatPercentage,
      'pricePerLiter': pricePerLiter,
      'totalRevenue': totalRevenue,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MilkEntryModel copyWith({
    String? id,
    String? userId,
    DateTime? date,
    String? shift,
    double? quantityLiters,
    double? fatPercentage,
    double? pricePerLiter,
    double? totalRevenue,
    String? notes,
    DateTime? createdAt,
  }) {
    return MilkEntryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      shift: shift ?? this.shift,
      quantityLiters: quantityLiters ?? this.quantityLiters,
      fatPercentage: fatPercentage ?? this.fatPercentage,
      pricePerLiter: pricePerLiter ?? this.pricePerLiter,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
