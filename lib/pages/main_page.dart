import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/book_controller.dart';
import '../controllers/profile_controller.dart';
import '../utils/app_routes.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'statistics_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller sudah diinisialisasi di main.dart
    final authC = Get.find<AuthController>();
    final bookC = Get.find<BookController>();
    final profileC = Get.find<ProfileController>();

    // Gunakan RxInt untuk melacak tab yang aktif
    final RxInt currentIndex = 0.obs;

    return Scaffold(
      body: Obx(() {
        // Tampilkan halaman sesuai index
        switch (currentIndex.value) {
          case 0:
            return const HomePage();
          case 1:
            return const StatisticsPage();
          case 2:
            return const ProfilePage();
          default:
            return const HomePage();
        }
      }),
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8D6E63), Color(0xFF5D4037)],
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex.value,
            onTap: (index) {
              // Hanya ubah index, tidak perlu navigasi
              currentIndex.value = index;
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.brown.shade200,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
          ),
        );
      }),
      floatingActionButton: Obx(() {
        // Hanya tampilkan FAB di halaman home
        if (currentIndex.value == 0) {
          return FloatingActionButton(
            onPressed: () => Get.toNamed(AppRoutes.addBook),
            backgroundColor: const Color(0xFF5D4037),
            child: const Icon(Icons.add),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
