import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  final String userId;
  final String name;
  final String phone;
  final String? address;
  final double currentBalance; // Positive = Customer owes money, Negative = Prepaid
  final double totalBought;
  final double totalPaid;
  final DateTime createdAt;

  const CustomerModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.address,
    this.currentBalance = 0.0,
    this.totalBought = 0.0,
    this.totalPaid = 0.0,
    required this.createdAt,
  });

  factory CustomerModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    return CustomerModel(
      id: id,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'],
      currentBalance: (map['currentBalance'] as num?)?.toDouble() ?? 0.0,
      totalBought: (map['totalBought'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (map['totalPaid'] as num?)?.toDouble() ?? 0.0,
      createdAt: parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'currentBalance': currentBalance,
      'totalBought': totalBought,
      'totalPaid': totalPaid,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'],
      currentBalance: (json['currentBalance'] as num?)?.toDouble() ?? 0.0,
      totalBought: (json['totalBought'] as num?)?.toDouble() ?? 0.0,
      totalPaid: (json['totalPaid'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'phone': phone,
      'address': address,
      'currentBalance': currentBalance,
      'totalBought': totalBought,
      'totalPaid': totalPaid,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  CustomerModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? phone,
    String? address,
    double? currentBalance,
    double? totalBought,
    double? totalPaid,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      currentBalance: currentBalance ?? this.currentBalance,
      totalBought: totalBought ?? this.totalBought,
      totalPaid: totalPaid ?? this.totalPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LedgerTransactionModel {
  final String id;
  final String customerId;
  final String userId;
  final DateTime date;
  final String transactionType; // 'sale' (milk bought) or 'payment' (cash received)
  final double milkQuantityLiters;
  final double ratePerLiter;
  final String? shift; // 'Morning' or 'Evening' (for sales only)
  final double amount; // Sale total or Payment total
  final double previousBalance;
  final double newBalance;
  final String? notes;
  final DateTime createdAt;

  const LedgerTransactionModel({
    required this.id,
    required this.customerId,
    required this.userId,
    required this.date,
    required this.transactionType,
    this.milkQuantityLiters = 0.0,
    this.ratePerLiter = 0.0,
    this.shift,
    required this.amount,
    required this.previousBalance,
    required this.newBalance,
    this.notes,
    required this.createdAt,
  });

  bool get isSale => transactionType.toLowerCase() == 'sale';
  bool get isPayment => transactionType.toLowerCase() == 'payment';

  factory LedgerTransactionModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic date) {
      if (date is Timestamp) return date.toDate();
      if (date is String) return DateTime.tryParse(date) ?? DateTime.now();
      return DateTime.now();
    }

    return LedgerTransactionModel(
      id: id,
      customerId: map['customerId'] ?? '',
      userId: map['userId'] ?? '',
      date: parseDate(map['date']),
      transactionType: map['transactionType'] ?? 'sale',
      milkQuantityLiters: (map['milkQuantityLiters'] as num?)?.toDouble() ?? 0.0,
      ratePerLiter: (map['ratePerLiter'] as num?)?.toDouble() ?? 0.0,
      shift: map['shift'],
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      previousBalance: (map['previousBalance'] as num?)?.toDouble() ?? 0.0,
      newBalance: (map['newBalance'] as num?)?.toDouble() ?? 0.0,
      notes: map['notes'],
      createdAt: parseDate(map['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'transactionType': transactionType,
      'milkQuantityLiters': milkQuantityLiters,
      'ratePerLiter': ratePerLiter,
      'shift': shift,
      'amount': amount,
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory LedgerTransactionModel.fromJson(Map<String, dynamic> json) {
    return LedgerTransactionModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      transactionType: json['transactionType'] ?? 'sale',
      milkQuantityLiters: (json['milkQuantityLiters'] as num?)?.toDouble() ?? 0.0,
      ratePerLiter: (json['ratePerLiter'] as num?)?.toDouble() ?? 0.0,
      shift: json['shift'],
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      previousBalance: (json['previousBalance'] as num?)?.toDouble() ?? 0.0,
      newBalance: (json['newBalance'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'userId': userId,
      'date': date.toIso8601String(),
      'transactionType': transactionType,
      'milkQuantityLiters': milkQuantityLiters,
      'ratePerLiter': ratePerLiter,
      'shift': shift,
      'amount': amount,
      'previousBalance': previousBalance,
      'newBalance': newBalance,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  LedgerTransactionModel copyWith({
    String? id,
    String? customerId,
    String? userId,
    DateTime? date,
    String? transactionType,
    double? milkQuantityLiters,
    double? ratePerLiter,
    String? shift,
    double? amount,
    double? previousBalance,
    double? newBalance,
    String? notes,
    DateTime? createdAt,
  }) {
    return LedgerTransactionModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      transactionType: transactionType ?? this.transactionType,
      milkQuantityLiters: milkQuantityLiters ?? this.milkQuantityLiters,
      ratePerLiter: ratePerLiter ?? this.ratePerLiter,
      shift: shift ?? this.shift,
      amount: amount ?? this.amount,
      previousBalance: previousBalance ?? this.previousBalance,
      newBalance: newBalance ?? this.newBalance,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
