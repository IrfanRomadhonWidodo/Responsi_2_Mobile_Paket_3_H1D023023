//controllers/book_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/book_model.dart';
import 'package:flutter/material.dart';

class BookController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<BookModel> books = <BookModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('books').get();

      books.clear();
      for (var doc in snapshot.docs) {
        books.add(BookModel.fromMap(doc.id, doc.data()));
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data buku: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addBook(BookModel book) async {
    try {
      isLoading.value = true;
      await _firestore.collection('books').add(book.toMap());
      Get.back();
      Get.snackbar(
        "Berhasil",
        "Buku berhasil ditambahkan",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      fetchBooks();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menambah buku: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateBook(String id, BookModel book) async {
    try {
      isLoading.value = true;
      await _firestore.collection('books').doc(id).update(book.toMap());
      Get.back();
      Get.snackbar(
        "Berhasil",
        "Buku berhasil diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      fetchBooks();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memperbarui buku: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBook(String id) async {
    try {
      isLoading.value = true;
      await _firestore.collection('books').doc(id).delete();
      Get.back();
      Get.snackbar(
        "Berhasil",
        "Buku berhasil dihapus",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      fetchBooks();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal menghapus buku: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
