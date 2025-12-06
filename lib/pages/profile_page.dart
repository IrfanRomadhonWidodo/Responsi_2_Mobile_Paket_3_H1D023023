import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authC = Get.find<AuthController>();
  final profileC = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Saya"),
        actions: [
          IconButton(
            onPressed: () => authC.logout(),
            icon: const Icon(Icons.logout),
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
          child: Obx(() {
            if (profileC.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF5D4037)),
              );
            }

            return Column(
              children: [
                // Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.brown.shade200,
                    border: Border.all(color: Colors.brown, width: 2),
                  ),
                  child: profileC.currentUser.value.photoUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profileC.currentUser.value.photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.brown.shade700,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.brown.shade700,
                        ),
                ),
                const SizedBox(height: 24),

                // Info Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Name
                        ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: Color(0xFF5D4037),
                          ),
                          title: const Text("Nama"),
                          subtitle: Text(profileC.currentUser.value.name),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: Color(0xFF5D4037),
                            ),
                            onPressed: () => _showEditNameDialog(),
                          ),
                        ),
                        const Divider(),

                        // Email
                        ListTile(
                          leading: const Icon(
                            Icons.email,
                            color: Color(0xFF5D4037),
                          ),
                          title: const Text("Email"),
                          subtitle: Text(profileC.currentUser.value.email),
                        ),
                        const Divider(),

                        // Member Since
                        ListTile(
                          leading: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF5D4037),
                          ),
                          title: const Text("Bergabung Sejak"),
                          subtitle: profileC.currentUser.value.createdAt != null
                              ? Text(
                                  "${profileC.currentUser.value.createdAt!.day}-${profileC.currentUser.value.createdAt!.month}-${profileC.currentUser.value.createdAt!.year}",
                                )
                              : const Text("Tidak tersedia"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Account Settings
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Color(0xFF5D4037),
                        ),
                        title: const Text("Ubah Password"),
                        onTap: () => _showChangePasswordDialog(),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(
                          Icons.help,
                          color: Color(0xFF5D4037),
                        ),
                        title: const Text("Bantuan"),
                        onTap: () => _showHelpDialog(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showEditNameDialog() {
    final nameC = TextEditingController(text: profileC.currentUser.value.name);

    Get.dialog(
      AlertDialog(
        title: const Text("Ubah Nama"),
        content: TextField(
          controller: nameC,
          decoration: const InputDecoration(
            labelText: "Nama",
            hintText: "Masukkan nama baru",
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          Obx(
            () => ElevatedButton(
              onPressed: profileC.isLoading.value
                  ? null
                  : () {
                      if (nameC.text.trim().isNotEmpty) {
                        profileC.updateProfile(nameC.text.trim());
                      }
                    },
              child: profileC.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Simpan"),
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordC = TextEditingController();
    final newPasswordC = TextEditingController();
    final confirmPasswordC = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.dialog(
      AlertDialog(
        title: const Text("Ubah Password"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Masukkan password saat ini dan password baru Anda",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Password saat ini
              Obx(
                () => TextFormField(
                  controller: currentPasswordC,
                  obscureText: authC.isHidden.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password saat ini tidak boleh kosong';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Password Saat Ini",
                    hintText: "Masukkan password saat ini",
                    suffixIcon: IconButton(
                      icon: Icon(
                        authC.isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF8D6E63),
                      ),
                      onPressed: () => authC.togglePasswordVisibility(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Password baru
              Obx(
                () => TextFormField(
                  controller: newPasswordC,
                  obscureText: authC.isHidden.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password baru tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Password Baru",
                    hintText: "Masukkan password baru",
                    suffixIcon: IconButton(
                      icon: Icon(
                        authC.isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF8D6E63),
                      ),
                      onPressed: () => authC.togglePasswordVisibility(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Konfirmasi password baru
              Obx(
                () => TextFormField(
                  controller: confirmPasswordC,
                  obscureText: authC.isHidden.value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != newPasswordC.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password Baru",
                    hintText: "Masukkan kembali password baru",
                    suffixIcon: IconButton(
                      icon: Icon(
                        authC.isHidden.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: const Color(0xFF8D6E63),
                      ),
                      onPressed: () => authC.togglePasswordVisibility(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          Obx(
            () => ElevatedButton(
              onPressed: authC.isLoading.value
                  ? null
                  : () {
                      if (formKey.currentState!.validate()) {
                        authC.updatePassword(
                          currentPasswordC.text.trim(),
                          newPasswordC.text.trim(),
                        );
                      }
                    },
              child: authC.isLoading.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text("Simpan"),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Bantuan"),
        content: const Text(
          "Jika Anda mengalikan masalah dengan aplikasi, silakan hubungi tim dukungan kami melalui email irfanromadhonwidodo86@gmail.com.",
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Tutup")),
        ],
      ),
    );
  }
}
