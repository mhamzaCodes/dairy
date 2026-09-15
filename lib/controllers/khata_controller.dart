import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../data/models/customer_ledger_model.dart';
import 'auth_controller.dart';

/// GetX KhataController managing customer ledger accounts, running balances,
/// and atomic Firestore transactions for Milk Sales & Payments Received.
class KhataController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reactive State
  final RxList<CustomerModel> customers = <CustomerModel>[].obs;
  final RxList<LedgerTransactionModel> selectedCustomerHistory = <LedgerTransactionModel>[].obs;
  final Rxn<CustomerModel> activeCustomer = Rxn<CustomerModel>();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<QuerySnapshot>? _customersSubscription;
  StreamSubscription<QuerySnapshot>? _historySubscription;

  /// Active User ID getter from AuthController
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
          bindCustomersStream();
        } else {
          _clearSubscriptions();
        }
      });
      if (AuthController.instance.isLoggedIn) {
        bindCustomersStream();
      }
    }
  }

  @override
  void onClose() {
    _clearSubscriptions();
    super.onClose();
  }

  void _clearSubscriptions() {
    _customersSubscription?.cancel();
    _historySubscription?.cancel();
    customers.clear();
    selectedCustomerHistory.clear();
    activeCustomer.value = null;
  }

  /// Listens to real-time updates from `users/{uid}/customers`
  void bindCustomersStream() {
    final uid = _currentUid;
    if (uid == null) return;

    _customersSubscription?.cancel();
    _customersSubscription = _db
        .collection('users')
        .doc(uid)
        .collection('customers')
        .orderBy('name', descending: false)
        .snapshots()
        .listen((snapshot) {
      customers.value = snapshot.docs
          .map((doc) => CustomerModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming customers: $e');
    });
  }

  /// Filtered customers list based on search query
  List<CustomerModel> get filteredCustomers {
    if (searchQuery.value.trim().isEmpty) {
      return customers;
    }
    final query = searchQuery.value.toLowerCase().trim();
    return customers.where((c) {
      return c.name.toLowerCase().contains(query) || c.phone.contains(query);
    }).toList();
  }

  /// Total sum of remaining balance owed by all customers
  double get totalOutstandingBalance {
    return customers.fold(0.0, (sum, customer) => sum + customer.currentBalance);
  }

  /// Adds a new customer document under `users/{uid}/customers`
  Future<bool> addCustomer({
    required String name,
    required String phone,
    String? address,
    double initialBalance = 0.0,
  }) async {
    final uid = _currentUid;
    if (uid == null) {
      _showErrorSnackbar('Auth Error', 'You must be signed in to add a customer.');
      return false;
    }

    if (name.trim().isEmpty) {
      _showErrorSnackbar('Validation Error', 'Customer name is required.');
      return false;
    }

    try {
      isLoading.value = true;
      final docRef = _db.collection('users').doc(uid).collection('customers').doc();

      final customer = CustomerModel(
        id: docRef.id,
        userId: uid,
        name: name.trim(),
        phone: phone.trim(),
        address: address?.trim(),
        currentBalance: initialBalance,
        totalBought: initialBalance > 0 ? initialBalance : 0.0,
        totalPaid: 0.0,
        createdAt: DateTime.now(),
      );

      await docRef.set(customer.toMap());

      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessSnackbar('Success', 'Customer ${customer.name} added to Khata.');
      });
      return true;
    } catch (e) {
      _showErrorSnackbar('Error', 'Failed to add customer: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Listens to real-time history stream for a specific customer:
  /// `users/{uid}/customers/{customerId}/ledger_history`
  void bindCustomerHistory(String customerId) {
    final uid = _currentUid;
    if (uid == null) return;

    _historySubscription?.cancel();
    _historySubscription = _db
        .collection('users')
        .doc(uid)
        .collection('customers')
        .doc(customerId)
        .collection('ledger_history')
        .orderBy('date', descending: true)
        .snapshots()
        .listen((snapshot) {
      selectedCustomerHistory.value = snapshot.docs
          .map((doc) => LedgerTransactionModel.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      debugPrint('Error streaming customer history: $e');
    });
  }

  /// Adds a new ledger transaction (Milk Sale or Cash Payment Received)
  /// Uses a Firestore **`runTransaction`** to guarantee atomic balance updates:
  /// Formula: Updated Balance = Previous Balance + Milk Sale Amount - Payment Received
  Future<bool> addLedgerTransaction({
    required String customerId,
    required String transactionType, // 'sale' or 'payment'
    required double amount,
    double milkQuantityLiters = 0.0,
    double ratePerLiter = 0.0,
    String? shift,
    String? notes,
    DateTime? transactionDate,
  }) async {
    final uid = _currentUid;
    if (uid == null) {
      _showErrorSnackbar('Auth Error', 'You must be logged in.');
      return false;
    }

    if (amount <= 0) {
      _showErrorSnackbar('Invalid Amount', 'Please enter a valid amount.');
      return false;
    }

    try {
      isLoading.value = true;
      final customerRef = _db
          .collection('users')
          .doc(uid)
          .collection('customers')
          .doc(customerId);

      final historyRef = customerRef.collection('ledger_history').doc();
      
      // Also log globally to daily_sales if it's a sale
      final globalSalesRef = _db.collection('users').doc(uid).collection('daily_sales').doc(historyRef.id);

      final date = transactionDate ?? DateTime.now();
      final isSale = transactionType.toLowerCase() == 'sale';

      await _db.runTransaction((transaction) async {
        final customerSnapshot = await transaction.get(customerRef);
        if (!customerSnapshot.exists) {
          throw Exception('Customer profile does not exist.');
        }

        final customerData = customerSnapshot.data()!;
        final double prevBalance = (customerData['currentBalance'] as num?)?.toDouble() ?? 0.0;
        final double prevTotalBought = (customerData['totalBought'] as num?)?.toDouble() ?? 0.0;
        final double prevTotalPaid = (customerData['totalPaid'] as num?)?.toDouble() ?? 0.0;

        // Formula: Updated Balance = Previous Balance + Milk Amount - Payment Received
        final double milkAmount = isSale ? amount : 0.0;
        final double paymentAmount = isSale ? 0.0 : amount;
        final double newBalance = prevBalance + milkAmount - paymentAmount;

        final double newTotalBought = prevTotalBought + milkAmount;
        final double newTotalPaid = prevTotalPaid + paymentAmount;

        // 1. Update Customer Record
        transaction.update(customerRef, {
          'currentBalance': newBalance,
          'totalBought': newTotalBought,
          'totalPaid': newTotalPaid,
        });

        // 2. Insert Transaction History Entry
        final ledgerTransaction = LedgerTransactionModel(
          id: historyRef.id,
          customerId: customerId,
          userId: uid,
          date: date,
          transactionType: isSale ? 'sale' : 'payment',
          milkQuantityLiters: milkQuantityLiters,
          ratePerLiter: ratePerLiter,
          shift: shift,
          amount: amount,
          previousBalance: prevBalance,
          newBalance: newBalance,
          notes: notes?.trim(),
          createdAt: DateTime.now(),
        );

        transaction.set(historyRef, ledgerTransaction.toMap());
        
        // 3. Insert to global daily_sales if it's a sale
        if (isSale) {
           transaction.set(globalSalesRef, ledgerTransaction.toMap());
        }
      });

      Future.delayed(const Duration(milliseconds: 300), () {
        _showSuccessSnackbar(
          'Transaction Saved',
          isSale ? 'Milk sale recorded successfully.' : 'Payment received recorded.',
        );
      });
      return true;
    } catch (e) {
      _showErrorSnackbar('Transaction Error', 'Failed to update ledger: $e');
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
