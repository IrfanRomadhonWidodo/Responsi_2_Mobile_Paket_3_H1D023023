import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Tambahkan import ini
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  // Ubah ke StatefulWidget
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authC = Get.find<AuthController>();
  // Pindahkan controller ke level state
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Atur tema status bar dan navigation bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFF5D4037),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8D6E63), Color(0xFF5D4037), Color(0xFF3E2723)],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo atau Ilustrasi
                      Container(
                        height: 120,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Judul Aplikasi
                      const Text(
                        "Inventaris Buku Irfan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Silakan login untuk melanjutkan",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD7CCC8),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Card Form
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Email Field
                              TextFormField(
                                controller: emailC,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(
                                  color: Color(0xFF3E2723),
                                ),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  labelStyle: const TextStyle(
                                    color: Color(0xFF8D6E63),
                                  ),
                                  hintText: "Masukkan email Anda",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF8D6E63),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD7CCC8),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD7CCC8),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF8D6E63),
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade50,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password Field
                              Obx(() {
                                return TextFormField(
                                  controller: passC,
                                  obscureText: authC.isHidden.value,
                                  style: const TextStyle(
                                    color: Color(0xFF3E2723),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF8D6E63),
                                    ),
                                    hintText: "Masukkan password Anda",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.lock_outline,
                                      color: Color(0xFF8D6E63),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        authC.isHidden.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: const Color(0xFF8D6E63),
                                      ),
                                      onPressed: () =>
                                          authC.togglePasswordVisibility(),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD7CCC8),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD7CCC8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF8D6E63),
                                        width: 2,
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                );
                              }),
                              const SizedBox(height: 8),

                              // Lupa Password
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () =>
                                      Get.toNamed('/forgot-password'),
                                  child: const Text(
                                    "Lupa Password?",
                                    style: TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Login Button
                              Obx(() {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: authC.isLoading.value
                                        ? null
                                        : () => authC.login(
                                            emailC.text.trim(),
                                            passC.text.trim(),
                                          ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF5D4037),
                                      foregroundColor: Colors.white,
                                      elevation: 3,
                                      shadowColor: const Color(0xFF3E2723),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: authC.isLoading.value
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                );
                              }),
                              const SizedBox(height: 20),

                              // Register Link
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Belum punya akun?",
                                    style: TextStyle(color: Color(0xFF5D4037)),
                                  ),
                                  TextButton(
                                    onPressed: () => Get.toNamed('/register'),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Color(0xFF8D6E63),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
