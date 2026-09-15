import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../data/models/cattle_model.dart';
import 'auth_controller.dart';

/// GetX HerdController managing animal asset records in `users/{uid}/cattle`.
class HerdController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reactive State
  final RxList<CattleModel> cattleList = <CattleModel>[].obs;
  final RxString selectedTypeFilter = 'All'.obs; // 'All', 'Cow', 'Buffalo'
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<QuerySnapshot>? _cattleSubscription;

  /// Active User ID getter
  String? get _currentUid {
    if (Get.isRegistered<AuthController>()) {
      return AuthController.instance.currentUid;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<AuthController>()) {
      ever(AuthController.instance.firebaseUser, (user) {
        if (user != null) {
          bindCattleStream();
        } else {
          _clearSubscriptions();
        }
      });
      if (AuthController.instance.isLoggedIn) {
        bindCattleStream();
      }
    }
  }

  @override
  void onClose() {
    _clearSubscriptions();
    super.onClose();
  }

  void _clearSubscriptions() {
    _cattleSubscription?.cancel();
    cattleList.clear();
  }

  /// Real-time stream of cattle from `users/{uid}/cattle`
  void bindCattleStream() {
    final uid = _currentUid;
    if (uid == null) return;

    _cattleSubscription?.cancel();
    _cattleSubscription = _db
        .collection('users')
        .doc(uid)
        .collection('cattle')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      cattleList.value = snapshot.docs
          .map((doc) => CattleModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming cattle: $e');
    });
  }

  /// Returns cattle filtered by type selection ('All', 'Cow', 'Buffalo') and search query
  List<CattleModel> get filteredCattleList {
    List<CattleModel> list = cattleList;

    if (selectedTypeFilter.value != 'All') {
      list = list
          .where((c) => c.type.toLowerCase() == selectedTypeFilter.value.toLowerCase())
          .toList();
    }

    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.toLowerCase().trim();
      list = list.where((c) {
        return c.tagId.toLowerCase().contains(query) ||
            c.breed.toLowerCase().contains(query) ||
            (c.motherTagId != null && c.motherTagId!.toLowerCase().contains(query));
      }).toList();
    }

    return list;
  }

  // Summary Metrics
  int get totalCattleCount => cattleList.length;
  int get totalCowsCount => cattleList.where((c) => c.isCow).length;
  int get totalBuffaloesCount => cattleList.where((c) => c.isBuffalo).length;

  double get totalDailyCapacity =>
      cattleList.fold(0.0, (sum, cattle) => sum + cattle.averageYield);

  /// Registers a new cattle entry into `users/{uid}/cattle`
  Future<bool> registerCattle({
    required String tagId,
    required String type, // 'Cow' or 'Buffalo'
    required String breed,
    required double averageYield,
    String? motherTagId,
    DateTime? purchaseDate,
    String? notes,
  }) async {
    final uid = _currentUid;
    if (uid == null) {
      _showErrorSnackbar('Auth Error', 'You must be logged in to add cattle.');
      return false;
    }

    if (tagId.trim().isEmpty) {
      _showErrorSnackbar('Validation Error', 'Cattle Tag ID is required.');
      return false;
    }

    try {
      isLoading.value = true;
      final docRef = _db.collection('users').doc(uid).collection('cattle').doc();

      final cattle = CattleModel(
        id: docRef.id,
        userId: uid,
        tagId: tagId.trim().toUpperCase(),
        type: type,
        breed: breed.trim(),
        averageYield: averageYield,
        motherTagId: motherTagId?.trim().toUpperCase(),
        purchaseDate: purchaseDate,
        notes: notes?.trim(),
        createdAt: DateTime.now(),
      );

      await docRef.set(cattle.toMap());

      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessSnackbar('Animal Added', 'Tag ${cattle.tagId} registered successfully.');
      });
      return true;
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to register animal: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Deletes a cattle record from Firestore
  Future<bool> deleteCattle(String cattleId) async {
    final uid = _currentUid;
    if (uid == null) return false;

    try {
      isLoading.value = true;
      await _db
          .collection('users')
          .doc(uid)
          .collection('cattle')
          .doc(cattleId)
          .delete();

      _showSuccessSnackbar('Deleted', 'Animal record removed.');
      return true;
    } catch (e) {
      _showErrorSnackbar('Delete Error', 'Failed to delete record: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
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
