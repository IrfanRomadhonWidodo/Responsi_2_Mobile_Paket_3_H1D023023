import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'controllers/auth_controller.dart';
import 'controllers/book_controller.dart';
import 'controllers/profile_controller.dart';
import 'utils/app_routes.dart';
import 'pages/auth/login_page.dart';
import 'pages/auth/register_page.dart';
import 'pages/main_page.dart';
import 'pages/home_page.dart';
import 'pages/add_book_page.dart';
import 'pages/book_detail_page.dart';
import 'pages/edit_book_page.dart';
import 'pages/statistics_page.dart';
import 'pages/profile_page.dart';
import 'models/book_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Inisialisasi controllers
  Get.put(AuthController());
  Get.put(BookController());
  Get.put(ProfileController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Responsi 2 Mobile Paket 3 H1D023023",
      theme: ThemeData(
        primarySwatch: Colors.brown,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          centerTitle: true,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.brown, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: AppRoutes.login,
      getPages: [
        GetPage(name: AppRoutes.login, page: () => const LoginPage()),
        GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
        GetPage(
          name: AppRoutes.main,
          page: () => const MainPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.home,
          page: () => const HomePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.statistics,
          page: () => const StatisticsPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.profile,
          page: () => const ProfilePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.addBook,
          page: () => const AddBookPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.bookDetail,
          page: () {
            // Ambil argument yang dikirim dari navigasi
            final book = Get.arguments as BookModel;
            return BookDetailPage(book: book);
          },
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AppRoutes.editBook,
          page: () {
            // Ambil argument yang dikirim dari navigasi
            final book = Get.arguments as BookModel;
            return EditBookPage(book: book);
          },
          middlewares: [AuthMiddleware()],
        ),
      ],
    );
  }
}

// Middleware untuk autentikasi
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Jika user belum login dan mencoba mengakses halaman yang memerlukan auth
    if (authController.firebaseUser.value == null &&
        route != AppRoutes.login &&
        route != AppRoutes.register) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // Jika user sudah login dan mencoba mengakses halaman login/register
    if (authController.firebaseUser.value != null &&
        (route == AppRoutes.login || route == AppRoutes.register)) {
      return const RouteSettings(name: AppRoutes.main);
    }

    return null;
  }
}
