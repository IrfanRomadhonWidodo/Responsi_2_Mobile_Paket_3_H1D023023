import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookC = Get.find<BookController>();

    return Scaffold(
      appBar: AppBar(title: const Text("Statistik Inventaris")),
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

          // Hitung statistik
          int totalBooks = bookC.books.length;
          int totalQuantity = bookC.books.fold(
            0,
            (sum, book) => sum + book.jumlah,
          );
          int totalValue = bookC.books.fold(
            0,
            (sum, book) => sum + (book.harga * book.jumlah),
          );
          int lowStockBooks = bookC.books
              .where((book) => book.jumlah <= 5)
              .length;
          int outOfStockBooks = bookC.books
              .where((book) => book.jumlah == 0)
              .length;

          return RefreshIndicator(
            onRefresh: () => bookC.fetchBooks(),
            color: const Color(0xFF5D4037),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Total Books Card
                  _buildStatCard(
                    "Total Buku",
                    totalBooks.toString(),
                    Icons.book,
                    Colors.brown,
                  ),
                  const SizedBox(height: 16),

                  // Total Quantity Card
                  _buildStatCard(
                    "Total Kuantitas",
                    "$totalQuantity buah",
                    Icons.inventory_2,
                    Colors.brown,
                  ),
                  const SizedBox(height: 16),

                  // Total Value Card
                  _buildStatCard(
                    "Total Nilai Inventaris",
                    "Rp ${totalValue.toString()}",
                    Icons.money,
                    Colors.green,
                  ),
                  const SizedBox(height: 16),

                  // Low Stock Card
                  _buildStatCard(
                    "Stok Menipis",
                    "$lowStockBooks judul",
                    Icons.warning,
                    Colors.orange,
                  ),
                  const SizedBox(height: 16),

                  // Out of Stock Card
                  _buildStatCard(
                    "Stok Habis",
                    "$outOfStockBooks judul",
                    Icons.error,
                    Colors.red,
                  ),
                  const SizedBox(height: 24),

                  // Stock Status Chart
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status Stok",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3E2723),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // In Stock
                          _buildStatusRow(
                            "Stok Tersedia",
                            totalBooks - lowStockBooks - outOfStockBooks,
                            totalBooks,
                            Colors.green,
                          ),
                          const SizedBox(height: 8),

                          // Low Stock
                          _buildStatusRow(
                            "Stok Menipis",
                            lowStockBooks,
                            totalBooks,
                            Colors.orange,
                          ),
                          const SizedBox(height: 8),

                          // Out of Stock
                          _buildStatusRow(
                            "Stok Habis",
                            outOfStockBooks,
                            totalBooks,
                            Colors.red,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, int count, int total, Color color) {
    double percentage = total > 0 ? count / total : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF5D4037)),
            ),
            Text(
              "$count ($total)",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5D4037),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: Colors.grey.shade300,
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}
