import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);
  Rx<UserModel> currentUser = UserModel(id: '', name: '', email: '').obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, (User? user) {
      if (user != null) {
        getUserData();
      }
    });
  }

  // Muat data user dari Firestore
  Future<void> getUserData() async {
    try {
      isLoading.value = true;

      final user = firebaseUser.value;
      if (user == null) return;

      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && doc.data() != null) {
        currentUser.value = UserModel.fromMap(
          user.uid,
          doc.data() as Map<String, dynamic>,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data profil: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update Nama di Firebase Auth & Firestore
  Future<void> updateProfile(String name) async {
    try {
      isLoading.value = true;

      final user = firebaseUser.value;
      if (user == null) return;

      await user.updateDisplayName(name);
      await _firestore.collection('users').doc(user.uid).update({'name': name});

      // Refresh local
      currentUser.update((val) {
        val!.name = name;
      });

      Get.back();
      Get.snackbar(
        "Berhasil",
        "Nama berhasil diperbarui!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui profil: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
