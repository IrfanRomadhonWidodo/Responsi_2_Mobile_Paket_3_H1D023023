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
    final emailC = TextEditingController(
      text: authC.firebaseUser.value?.email ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: const Text("Ubah Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Kami akan mengirimkan link reset password ke email Anda.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Masukkan email Anda",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Batal")),
          Obx(
            () => ElevatedButton(
              onPressed: authC.isLoading.value
                  ? null
                  : () {
                      if (emailC.text.trim().isNotEmpty) {
                        authC.resetPassword(emailC.text.trim());
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
                  : const Text("Kirim"),
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
