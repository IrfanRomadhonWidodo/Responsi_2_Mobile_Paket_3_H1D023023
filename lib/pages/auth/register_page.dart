import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authC = Get.find<AuthController>();
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final confirmPassC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    confirmPassC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Logo atau Ilustrasi
                      Container(
                        height: 100,
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
                        "Buat Akun Baru",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Silakan isi data untuk registrasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFD7CCC8),
                        ),
                      ),
                      const SizedBox(height: 30),

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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Name Field
                                TextFormField(
                                  controller: nameC,
                                  keyboardType: TextInputType.name,
                                  validator: (value) =>
                                      authC.validateName(value ?? ''),
                                  style: const TextStyle(
                                    color: Color(0xFF3E2723),
                                  ),
                                  decoration: InputDecoration(
                                    labelText: "Nama Lengkap",
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF8D6E63),
                                    ),
                                    hintText: "Masukkan nama lengkap Anda",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
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

                                // Email Field
                                TextFormField(
                                  controller: emailC,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) =>
                                      authC.validateEmail(value ?? ''),
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
                                    validator: (value) =>
                                        authC.validatePassword(value ?? ''),
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
                                const SizedBox(height: 20),

                                // Confirm Password Field
                                Obx(() {
                                  return TextFormField(
                                    controller: confirmPassC,
                                    obscureText: authC.isHidden.value,
                                    validator: (value) {
                                      if (value != passC.text) {
                                        return 'Password tidak cocok';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Color(0xFF3E2723),
                                    ),
                                    decoration: InputDecoration(
                                      labelText: "Konfirmasi Password",
                                      labelStyle: const TextStyle(
                                        color: Color(0xFF8D6E63),
                                      ),
                                      hintText:
                                          "Masukkan kembali password Anda",
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
                                const SizedBox(height: 24),

                                // Register Button
                                Obx(() {
                                  return SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: authC.isLoading.value
                                          ? null
                                          : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                authC.register(
                                                  nameC.text.trim(),
                                                  emailC.text.trim(),
                                                  passC.text.trim(),
                                                );
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF5D4037,
                                        ),
                                        foregroundColor: Colors.white,
                                        elevation: 3,
                                        shadowColor: const Color(0xFF3E2723),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
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
                                              "Register",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 20),

                                // Login Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Sudah punya akun?",
                                      style: TextStyle(
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        "Login",
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
