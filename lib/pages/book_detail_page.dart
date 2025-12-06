import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';
import '../utils/app_routes.dart';

class BookDetailPage extends StatelessWidget {
  final BookModel book;

  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final bookC = Get.find<BookController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Inventaris Irfan"),
        actions: [
          IconButton(
            // Perbaikan: Menggunakan named routes dengan arguments
            onPressed: () => Get.toNamed(AppRoutes.editBook, arguments: book),
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text("Konfirmasi Hapus"),
                  content: const Text(
                    "Apakah Anda yakin ingin menghapus buku ini?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Batal"),
                    ),
                    TextButton(
                      onPressed: () => bookC.deleteBook(book.id!),
                      child: const Text("Hapus"),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFEBE9), Color(0xFFD7CCC8)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    book.judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const Divider(height: 32, color: Color(0xFF8D6E63)),

                  // Informasi Buku
                  _buildInfoRow("Penulis", book.penulis),
                  const SizedBox(height: 12),
                  _buildInfoRow("Penerbit", book.penerbit),
                  const SizedBox(height: 12),
                  _buildInfoRow("Harga", "Rp ${book.harga.toString()}"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Jumlah", "${book.jumlah} buah"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Volume", "${book.volume} cm³"),
                  const SizedBox(height: 12),
                  _buildInfoRow("Tanggal Masuk", book.tanggalMasuk),
                  const SizedBox(height: 24),

                  // Status Stok
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: book.jumlah > 10
                          ? Colors.green.shade100
                          : book.jumlah > 0
                          ? Colors.orange.shade100
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: book.jumlah > 10
                            ? Colors.green.shade300
                            : book.jumlah > 0
                            ? Colors.orange.shade300
                            : Colors.red.shade300,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Status Stok",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: book.jumlah > 10
                                ? Colors.green.shade800
                                : book.jumlah > 0
                                ? Colors.orange.shade800
                                : Colors.red.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          book.jumlah > 10
                              ? "Stok Tersedia (${book.jumlah} buah)"
                              : book.jumlah > 0
                              ? "Stok Menipis (${book.jumlah} buah)"
                              : "Stok Habis",
                          style: TextStyle(
                            fontSize: 14,
                            color: book.jumlah > 10
                                ? Colors.green.shade700
                                : book.jumlah > 0
                                ? Colors.orange.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5D4037),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Color(0xFF3E2723)),
          ),
        ),
      ],
    );
  }
}
