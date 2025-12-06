import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';
import '../utils/app_routes.dart';
import 'add_book_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();
    final bookC = Get.find<BookController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventaris Buku Irfan"),
        // Hapus bagian actions di bawah ini
        // actions: [
        //   IconButton(
        //     onPressed: () => authC.logout(),
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
          ),
        ),
        child: Obx(() {
          if (bookC.isLoading.value && bookC.books.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF5D4037)),
            );
          }

          if (bookC.books.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: Colors.brown.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Belum ada data buku",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tekan tombol + untuk menambah buku",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => bookC.fetchBooks(),
            color: const Color(0xFF5D4037),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookC.books.length,
              itemBuilder: (context, index) {
                final book = bookC.books[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Perbaikan navigasi dengan mengirimkan book sebagai argument
                      Get.toNamed(AppRoutes.bookDetail, arguments: book);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  book.judul,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3E2723),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8D6E63),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "Stok: ${book.jumlah}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Penulis: ${book.penulis}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Penerbit: ${book.penerbit}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.brown.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rp ${book.harga.toString()}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D4037),
                                ),
                              ),
                              Text(
                                book.tanggalMasuk,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.brown.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addBook),
        backgroundColor: const Color(0xFF5D4037),
        child: const Icon(Icons.add),
      ),
    );
  }
}
