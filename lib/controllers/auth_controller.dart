import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/app_colors.dart';
import '../data/models/user_model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reactive State
  final Rxn<User> firebaseUser = Rxn<User>();
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  final RxBool isLoading = false.obs;

  StreamSubscription<User?>? _authSubscription;

  // Getters
  String? get currentUid => firebaseUser.value?.uid;
  bool get isLoggedIn => firebaseUser.value != null;
  UserModel? get currentUser => userModel.value;

  @override
  void onInit() {
    super.onInit();
    // Bind firebase auth state stream
    firebaseUser.bindStream(_auth.authStateChanges());
    _authSubscription = _auth.authStateChanges().listen(_handleAuthStateChange);
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }

  /// Handles user session state transitions
  void _handleAuthStateChange(User? user) async {
    if (user != null) {
      await fetchUserProfile(user.uid);
    } else {
      userModel.value = null;
    }
  }

  /// Fetches farmer profile from Firestore `users/{uid}`
  Future<void> fetchUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        userModel.value = UserModel.fromMap(doc.data()!, uid);
      }
    } catch (e) {
      _showErrorSnackbar('Error fetching profile', e.toString());
    }
  }

  /// Registers a new farmer via Firebase Auth and saves details to Firestore
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String farmName,
    required String phoneNumber,
  }) async {
    try {
      isLoading.value = true;
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String uid = credential.user!.uid;
      final newFarmer = UserModel(
        uid: uid,
        name: name.trim(),
        phoneNumber: phoneNumber.trim(),
        email: email.trim(),
        farmName: farmName.trim(),
        createdAt: DateTime.now(),
      );

      // Save user profile to users/{uid}
      await _db.collection('users').doc(uid).set(newFarmer.toMap());
      userModel.value = newFarmer;

      _showSuccessSnackbar('Welcome!', 'Farm profile created successfully.');
      return true;
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar('Registration Failed', _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _showErrorSnackbar('Registration Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in existing farmer with email and password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final String uid = credential.user!.uid;
      await fetchUserProfile(uid);

      _showSuccessSnackbar('Success', 'Logged in successfully.');
      return true;
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar('Login Failed', _getAuthErrorMessage(e));
      return false;
    } catch (e) {
      _showErrorSnackbar('Login Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      userModel.value = null;
      Get.offAllNamed(AppRoutes.LOGIN);
      _showSuccessSnackbar('Signed Out', 'You have been signed out.');
    } catch (e) {
      _showErrorSnackbar('Logout Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Maps Firebase Auth exception codes to clear user-friendly messages
  String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password should be at least 6 characters.';
      default:
        return e.message ?? 'An unexpected authentication error occurred.';
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
