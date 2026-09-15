import 'package:cloud_firestore/cloud_firestore.dart';

/// User Model representing a Dairy Farmer profile in Firebase Auth & Firestore.
class UserModel {
  final String uid;
  final String name;
  final String phoneNumber;
  final String email;
  final String farmName;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.farmName,
    required this.createdAt,
  });

  /// Factory constructor to parse Firestore documents into UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      farmName: map['farmName'] ?? '',
      createdAt: parseDate(map['createdAt']),
    );
  }

  /// Converts UserModel instance to a Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'farmName': farmName,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Factory constructor for JSON deserialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      farmName: json['farmName'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Converts UserModel instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'farmName': farmName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? phoneNumber,
    String? email,
    String? farmName,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      farmName: farmName ?? this.farmName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
