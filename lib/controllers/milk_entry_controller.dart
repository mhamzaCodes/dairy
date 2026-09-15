import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../data/models/customer_ledger_model.dart';
import '../data/models/milk_entry_model.dart';
import 'auth_controller.dart';

/// GetX Controller managing daily milk production records, reactive price calculation,
/// and Cloud Firestore operations scoped to `users/{uid}/milk_entries`.
class MilkEntryController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Form Reactive State
  final RxString selectedShift = 'Morning'.obs;
  final RxDouble quantityLiters = 0.0.obs;
  final RxDouble fatPercentage = 0.0.obs;
  final RxDouble pricePerLiter = 0.0.obs;
  final Rx<DateTime> entryDate = DateTime.now().obs;
  final RxBool isLoading = false.obs;

  // Real-time Collections State
  final RxList<MilkEntryModel> todayEntries = <MilkEntryModel>[].obs;
  final RxList<MilkEntryModel> weeklyEntries = <MilkEntryModel>[].obs;
  
  // Real-time Global Sales State
  final RxList<LedgerTransactionModel> todaySales = <LedgerTransactionModel>[].obs;

  StreamSubscription<QuerySnapshot>? _todaySubscription;
  StreamSubscription<QuerySnapshot>? _weeklySubscription;
  StreamSubscription<QuerySnapshot>? _todaySalesSubscription;

  /// Real-time reactive calculation of total revenue
  double get totalPrice => (quantityLiters.value * pricePerLiter.value);

  /// Helper to get active user ID from AuthController
  String? get _currentUid {
    if (Get.isRegistered<AuthController>()) {
      return AuthController.instance.currentUid;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    // Reactively bind streams when user auth state changes
    if (Get.isRegistered<AuthController>()) {
      ever(AuthController.instance.firebaseUser, (user) {
        if (user != null) {
          bindStreams();
        } else {
          _clearSubscriptions();
        }
      });
      if (AuthController.instance.isLoggedIn) {
        bindStreams();
      }
    }
  }

  @override
  void onClose() {
    _clearSubscriptions();
    super.onClose();
  }

  void _clearSubscriptions() {
    _todaySubscription?.cancel();
    _weeklySubscription?.cancel();
    _todaySalesSubscription?.cancel();
    todayEntries.clear();
    weeklyEntries.clear();
    todaySales.clear();
  }

  /// Binds Firestore streams for today and past 7 days milk production
  void bindStreams() {
    final uid = _currentUid;
    if (uid == null) return;

    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfWeek = startOfToday.subtract(const Duration(days: 6));

    // Today Stream
    _todaySubscription?.cancel();
    _todaySubscription = _db
        .collection('users')
        .doc(uid)
        .collection('milk_entries')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      todayEntries.value = snapshot.docs
          .map((doc) => MilkEntryModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming today milk entries: $e');
    });

    // Weekly Stream (Past 7 Days)
    _weeklySubscription?.cancel();
    _weeklySubscription = _db
        .collection('users')
        .doc(uid)
        .collection('milk_entries')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfWeek))
        .orderBy('date', descending: false)
        .snapshots()
        .listen((snapshot) {
      weeklyEntries.value = snapshot.docs
          .map((doc) => MilkEntryModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming weekly milk entries: $e');
    });

    // Today Sales Stream
    _todaySalesSubscription?.cancel();
    _todaySalesSubscription = _db
        .collection('users')
        .doc(uid)
        .collection('daily_sales')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfToday))
        .snapshots()
        .listen((snapshot) {
      todaySales.value = snapshot.docs
          .map((doc) => LedgerTransactionModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming today sales: $e');
    });
  }

  /// Saves a new milk production entry to `users/{uid}/milk_entries`
  Future<bool> addMilkEntry({String? notes}) async {
    final uid = _currentUid;
    if (uid == null) {
      _showErrorSnackbar('Auth Error', 'You must be signed in to add entries.');
      return false;
    }

    if (quantityLiters.value <= 0) {
      _showErrorSnackbar('Invalid Input', 'Please enter a valid milk quantity in liters.');
      return false;
    }

    if (pricePerLiter.value <= 0) {
      _showErrorSnackbar('Invalid Input', 'Please enter a valid rate per liter.');
      return false;
    }

    try {
      isLoading.value = true;
      final docRef = _db.collection('users').doc(uid).collection('milk_entries').doc();

      final entry = MilkEntryModel(
        id: docRef.id,
        userId: uid,
        date: entryDate.value,
        shift: selectedShift.value,
        quantityLiters: quantityLiters.value,
        fatPercentage: fatPercentage.value,
        pricePerLiter: pricePerLiter.value,
        totalRevenue: totalPrice,
        notes: notes?.trim(),
        createdAt: DateTime.now(),
      );

      await docRef.set(entry.toMap());
      resetForm();

      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessSnackbar('Success', 'Milk entry saved successfully.');
      });
      return true;
    } catch (e) {
      _showErrorSnackbar('Save Error', 'Failed to save milk entry: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Resets entry form fields
  void resetForm() {
    quantityLiters.value = 0.0;
    fatPercentage.value = 0.0;
    pricePerLiter.value = 0.0;
    selectedShift.value = 'Morning';
    entryDate.value = DateTime.now();
  }

  // Dashboard Aggregations

  // PRODUCTION
  double get todayTotalLiters => todayEntries.fold(0.0, (sum, entry) => sum + entry.quantityLiters);
  double get todayMorningLiters => todayEntries.where((e) => e.shift == 'Morning').fold(0.0, (sum, e) => sum + e.quantityLiters);
  double get todayEveningLiters => todayEntries.where((e) => e.shift == 'Evening').fold(0.0, (sum, e) => sum + e.quantityLiters);

  // SALES
  double get todayTotalSoldLiters => todaySales.fold(0.0, (sum, entry) => sum + entry.milkQuantityLiters);
  double get todayMorningSoldLiters => todaySales.where((e) => e.shift == 'Morning').fold(0.0, (sum, e) => sum + e.milkQuantityLiters);
  double get todayEveningSoldLiters => todaySales.where((e) => e.shift == 'Evening').fold(0.0, (sum, e) => sum + e.milkQuantityLiters);

  // REMAINING
  double get todayTotalRemaining => todayTotalLiters - todayTotalSoldLiters;
  double get todayMorningRemaining => todayMorningLiters - todayMorningSoldLiters;
  double get todayEveningRemaining => todayEveningLiters - todayEveningSoldLiters;

  /// Total revenue generated today (based on production valuation)
  double get todayTotalRevenue => todayEntries.fold(0.0, (sum, entry) => sum + entry.totalRevenue);

  /// Returns 7-day milk production mapped by day offset (0 = 6 days ago, 6 = Today)
  List<double> get weeklyLitersByDay {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    List<double> dailyTotals = List.filled(7, 0.0);

    for (var entry in weeklyEntries) {
      final entryDay = DateTime(entry.date.year, entry.date.month, entry.date.day);
      final difference = startOfToday.difference(entryDay).inDays;
      if (difference >= 0 && difference < 7) {
        int index = 6 - difference;
        dailyTotals[index] += entry.quantityLiters;
      }
    }
    return dailyTotals;
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.errorBg,
      colorText: AppColors.error,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 4),
    );
  }

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.successBg,
      colorText: AppColors.success,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }
}
