import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Reactive variables
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs; // Untuk toggle visibility password
  Rx<User?> firebaseUser = Rx<User?>(null); // Stream user authentication

  @override
  void onInit() {
    super.onInit();
    // Bind stream untuk mendengar perubahan auth state
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _handleAuthChange);
  }

  void _handleAuthChange(User? user) {
    if (user == null) {
      Get.offAllNamed(AppRoutes.login);
    } else {
      // Ubah dari '/home' ke '/main'
      Get.offAllNamed(AppRoutes.main);
    }
  }

  // Validasi input
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(email)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validateName(String name) {
    if (name.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    if (name.length < 3) {
      return 'Nama minimal 3 karakter';
    }
    return null;
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isHidden.value = !isHidden.value;
  }

  // Mendapatkan data user saat ini
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    if (_auth.currentUser == null) return null;

    try {
      final doc = await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .get();
      return doc.data();
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // Login dengan validasi
  Future<void> login(String email, String password) async {
    // Validasi input
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (emailError != null || passwordError != null) {
      Get.snackbar(
        "Validasi Gagal",
        emailError ?? passwordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Login ke Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Update user status di Firestore
      await _db.collection("users").doc(userCredential.user!.uid).update({
        "lastLogin": FieldValue.serverTimestamp(),
        "isActive": true,
      });

      // Ambil data user
      await getCurrentUserData();

      Get.snackbar(
        "Login Berhasil",
        "Selamat datang kembali!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah';
          break;
        case 'user-disabled':
          errorMessage = 'Akun telah dinonaktifkan';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        default:
          errorMessage = 'Login gagal: ${e.message}';
      }

      Get.snackbar(
        "Login Gagal",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Login Gagal",
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register dengan validasi
  Future<void> register(String name, String email, String password) async {
    // Validasi input
    final nameError = validateName(name);
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);

    if (nameError != null || emailError != null || passwordError != null) {
      Get.snackbar(
        "Validasi Gagal",
        nameError ?? emailError ?? passwordError!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Buat user di Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Simpan data user ke Firestore
      await _db.collection("users").doc(userCredential.user!.uid).set({
        "name": name.trim(),
        "email": email.trim(),
        "createdAt": FieldValue.serverTimestamp(),
        "lastLogin": FieldValue.serverTimestamp(),
        "isActive": true,
        "role": "user", // Default role
      });

      Get.snackbar(
        "Registrasi Berhasil",
        "Akun berhasil dibuat. Silakan login!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Redirect ke login
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operasi tidak diizinkan';
          break;
        case 'weak-password':
          errorMessage = 'Password terlalu lemah';
          break;
        default:
          errorMessage = 'Registrasi gagal: ${e.message}';
      }

      Get.snackbar(
        "Registrasi Gagal",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Registrasi Gagal",
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      isLoading.value = true;

      // Update user status di Firestore
      if (_auth.currentUser != null) {
        await _db.collection("users").doc(_auth.currentUser!.uid).update({
          "lastLogout": FieldValue.serverTimestamp(),
          "isActive": false,
        });
      }

      // Logout dari Firebase
      await _auth.signOut();

      Get.snackbar(
        "Logout Berhasil",
        "Anda telah keluar dari aplikasi",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Logout Gagal",
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    // Validasi email
    final emailError = validateEmail(email);
    if (emailError != null) {
      Get.snackbar(
        "Validasi Gagal",
        emailError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Kirim email reset password
      await _auth.sendPasswordResetEmail(email: email.trim());

      Get.snackbar(
        "Email Terkirim",
        "Link reset password telah dikirim ke $email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );

      // Kembali ke halaman login
      Get.offAllNamed(AppRoutes.login);
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak terdaftar';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        default:
          errorMessage = 'Gagal mengirim email: ${e.message}';
      }

      Get.snackbar(
        "Gagal Mengirim Email",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal Mengirim Email",
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update password langsung di aplikasi
  Future<void> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      isLoading.value = true;

      // Dapatkan user saat ini
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar(
          "Error",
          "Tidak ada pengguna yang login",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
        return;
      }

      // Buat kredensial untuk autentikasi ulang
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Autentikasi ulang user
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);

      Get.back();
      Get.snackbar(
        "Berhasil",
        "Password berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Password saat ini salah';
          break;
        case 'weak-password':
          errorMessage = 'Password baru terlalu lemah (minimal 6 karakter)';
          break;
        case 'requires-recent-login':
          errorMessage = 'Silakan login kembali untuk mengubah password';
          break;
        default:
          errorMessage = 'Gagal mengubah password: ${e.message}';
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
