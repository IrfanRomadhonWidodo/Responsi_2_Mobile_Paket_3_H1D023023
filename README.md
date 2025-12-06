![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue?logo=flutter&style=for-the-badge)
![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart&style=for-the-badge)
![Firebase Auth](https://img.shields.io/badge/Firebase-Auth-F5820B?logo=firebase&style=for-the-badge)
![Firestore](https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&style=for-the-badge)
![Backend](https://img.shields.io/badge/Backend-Firebase%20Cloud-039BE5?style=for-the-badge)
![API](https://img.shields.io/badge/API-RealTime%20Database-43A047?style=for-the-badge)
![StateMgmt](https://img.shields.io/badge/State%20Management-GetX-7B1FA2?style=for-the-badge)

# 📚 E-Library Manager: Aplikasi Manajemen Buku Berbasis Firebase

## 💻 Project Responsi II Mobile Programming (Paket 3)

Aplikasi mobile ini dikembangkan menggunakan **[Sebutkan Framework/Bahasa Anda, contoh: Flutter/Dart]** dan mengimplementasikan arsitektur **Model-View-Controller (MVC)** untuk mengelola data buku dan pengguna secara efisien. Seluruh operasi data ditangani secara *real-time* menggunakan layanan **Google Firebase**.

---

## 👨‍🎓 Informasi Pengembang

| Kategori | Detail |
| :--- | :--- |
| **Nama Lengkap** | **Irfan Romadhon Widodo** |
| **NIM** | **H1D023023** |
| **Asal Institusi** | **Universitas Jenderal Soedirman** |
| **Shift Lama** | D |
| **Shift Baru** | F |

---

## 🚀 Fitur Utama & Struktur Proyek

Aplikasi ini mendukung fungsionalitas **CRUD** (Create, Read, Update, Delete) penuh untuk data buku, dilengkapi dengan manajemen otentikasi.

### 📁 Struktur Proyek (`lib/`)
```
bash
lib/
│ firebase_options.dart
│ main.dart
├─ controllers/
│    auth_controller.dart
│    book_controller.dart
│    profile_controller.dart
├─ models/
│    book_model.dart
│    user_model.dart
├─ pages/
│   │ home_page.dart
│   │ add_book_page.dart
│   │ book_detail_page.dart
│   │ edit_book_page.dart
│   │ statistics_page.dart
│   │ profile_page.dart
│   └─ auth/
│        login_page.dart
│        register_page.dart
└─ utils/
     app_routes.dart
```
## 🛠️ Spesifikasi Layanan Backend (API) ☁️

Aplikasi E-Library Manager ini sepenuhnya mengandalkan **Google Firebase** untuk menyediakan infrastruktur *real-time* dan keamanan data.

| Layanan Firebase | Fungsi Utama dalam Aplikasi | Implementasi Kode Kunci |
| :--- | :--- | :--- |
| **1. Firebase Authentication** | Mengelola otentikasi pengguna (**Login** dan **Registrasi**). | **`auth_controller.dart`** menggunakan `createUserWithEmailAndPassword()` dan `signInWithEmailAndPassword()` untuk otentikasi. |
| **2. Cloud Firestore** | Basis data **NoSQL** yang digunakan untuk menyimpan data utama: `BookModel` dan `UserModel`. | **`book_controller.dart`** menggunakan `collection().snapshots()` untuk *real-time reading* dan `add()`, `update()`, `delete()` untuk operasi **CRUD** data buku. |

---

## 📖 Penjelasan Kode Detail per Fungsi

Penjelasan ini berfokus pada bagaimana logika di **`controllers/`** berinteraksi dengan Firebase untuk mencapai fungsionalitas aplikasi.

### 1. Otentikasi Pengguna (Firebase Auth & Firestore) 🔒

Bagian ini menjelaskan alur otentikasi pengguna menggunakan **Firebase Authentication** yang dikelola oleh `AuthController` dan bagaimana data profil awal disimpan ke **Cloud Firestore**.

| File | Fungsi Utama | Detail Implementasi & Interaksi |
| :--- | :--- | :--- |
| **`controllers/auth_controller.dart`** | **Registrasi** | Menggunakan `createUserWithEmailAndPassword()` untuk membuat user. Setelah berhasil, controller **secara otomatis** menyimpan data awal (`name`, `email`, `createdAt`, `role: "user"`) ke koleksi Firestore: `_db.collection("users").doc(userCredential.user!.uid).set(...)`. |
| **`controllers/auth_controller.dart`** | **Login** | Menggunakan `signInWithEmailAndPassword()` untuk verifikasi. Setelah login, controller melakukan *update* status (`isActive: true` dan `lastLogin`) di dokumen Firestore user yang bersangkutan. |
| **`controllers/auth_controller.dart`** | **Logout** | Menggunakan `_auth.signOut()`. Sebelum keluar, controller melakukan *update* status **`isActive: false`** di Firestore. |
| **`controllers/auth_controller.dart`** | **State Management** | Method `_handleAuthChange` di `onInit()` menggunakan **`_auth.authStateChanges()`** untuk memantau status login *real-time* dan melakukan *redirect* ke `/login` atau `/main`. |
| **`controllers/auth_controller.dart`** | **Password Recovery** | Terdapat fungsi **`resetPassword`** yang memanggil `_auth.sendPasswordResetEmail()` dan fungsi **`updatePassword`** yang memerlukan *re-autentikasi* pengguna. |
| **`pages/auth/login_page.dart`** | **View Login** | Memicu `authC.login(emailC.text, passC.text)`. Menggunakan **Obx** dari GetX untuk menampilkan *loading state* (`CircularProgressIndicator`) dan mengelola *toggle* **`isHidden`** (visibilitas password). |
| **`pages/auth/register_page.dart`** | **View Registrasi** | Memicu `authC.register(...)`. Halaman ini menyediakan *Form* input dan memanggil controller yang bertanggung jawab untuk validasi dan penyimpanan data awal ke Firebase. |

---
## 2. Manajemen Buku (CRUD - Cloud Firestore) 📚

Bagian ini menjelaskan detail implementasi operasi CRUD (Create, Read, Update, Delete) untuk entitas **Buku** (Inventaris) yang dikelola oleh `BookController` dan disimpan di koleksi Firestore **`books`**.

| File | Fungsi CRUD / Utama | Detail Implementasi & Interaksi |
| :--- | :--- | :--- |
| **`controllers/book_controller.dart`** | **C**reate (`addBook`) | Mengambil objek `BookModel` dan memanggil **`_firestore.collection('books').add(book.toMap())`**. Konversi dari objek Dart ke format Firestore dilakukan menggunakan *method* **`.toMap()`**. Setelah berhasil, memicu **`fetchBooks()`** untuk *refresh* data di UI. |
| **`controllers/book_controller.dart`** | **R**ead (`fetchBooks`) | Menggunakan *one-time fetch* **`await _firestore.collection('books').get()`**. Dokumen dikonversi menjadi `BookModel` menggunakan **`BookModel.fromMap(doc.id, doc.data())`**, kemudian disimpan ke **`RxList<BookModel> books`** milik GetX. |
| **`controllers/book_controller.dart`** | **U**pdate (`updateBook`) | Menerima **`id`** dokumen dan objek `BookModel` baru. Memanggil **`_firestore.collection('books').doc(id).update(book.toMap())`**. ID dokumen digunakan untuk menargetkan dokumen. |
| **`controllers/book_controller.dart`** | **D**elete (`deleteBook`) | Menerima **`id`** dokumen yang akan dihapus. Memanggil **`_firestore.collection('books').doc(id).delete()`**. Controller memanggil **`fetchBooks()`** untuk *refresh* list setelah operasi. |
| **`pages/add_book_page.dart`** | **View Create** | Menyediakan **`Form`** dengan validasi. Memanggil `bookC.addBook(...)` setelah validasi berhasil (data dikonversi ke `BookModel`). |
| **`pages/edit_book_page.dart`** | **View Update** | Menginisialisasi *TextController* dengan data yang diterima. Memanggil `bookC.updateBook(book.id!, book)` saat tombol **Update** ditekan. |
| **`pages/book_detail.dart`** | **View Detail/Actions** | Menampilkan detail buku. Ikon **Delete** memicu **`AlertDialog`** konfirmasi sebelum memanggil **`bookC.deleteBook(book.id!)`**. |

---
## 3. Model Data & Konversi (Mapping) 🔄

Bagian ini menjelaskan struktur *Model* data utama (`BookModel` dan `UserModel`) dan bagaimana mereka bertanggung jawab melakukan konversi data dua arah (**Dart Object $\leftrightarrow$ Firestore Map**).

| File | Fungsi Utama | Penjelasan Snippet Kode Inti |
| :--- | :--- | :--- |
| **`models/book_model.dart`** | **Dart Object $\to$ Firestore Map** | Metode **`toMap()`** mengambil semua *field* dari objek `BookModel` dan mengubahnya menjadi `Map<String, dynamic>`. Ini dipanggil saat operasi **Create** atau **Update** di `BookController`. |
| **`models/book_model.dart`** | **Firestore Map $\to$ Dart Object** | *Factory constructor* **`BookModel.fromMap(String id, Map<String, dynamic> map)`** menerima data Map dari Firestore dan Document ID, lalu membangun kembali objek `BookModel` (termasuk *id*-nya). Ini dipanggil saat operasi **Read** di `BookController`. |
| **`models/user_model.dart`** | **Konversi Waktu (Timestamp)** | Dalam **`UserModel.fromMap`**, *field* `createdAt` secara spesifik dikonversi dari tipe data Firestore **`Timestamp`** menjadi objek **`DateTime`** Dart menggunakan `(map['createdAt'] as Timestamp).toDate()`. |
| **`models/user_model.dart`** | **Firestore Mapping** | Memiliki metode **`toMap()`** dan *factory* **`UserModel.fromMap`** yang mirip dengan `BookModel`, digunakan oleh `AuthController` untuk menyimpan data profil pengguna baru ke koleksi `users` dan membaca profil saat *login*. |

---
---
## 4. Manajemen Profil & Tampilan Data (Home, Profile, Statistics) 👤📊

Bagian ini menjelaskan fungsionalitas non-CRUD utama, yaitu: menampilkan data pengguna, memperbarui profil, mengelola sesi, dan menyajikan ringkasan inventaris dalam bentuk statistik.

| File | Fungsi Utama | Detail Implementasi & Interaksi |
| :--- | :--- | :--- |
| **`controllers/profile_controller.dart`** | **Muat Data Profil** (`getUserData`) | Dipanggil di `onInit()` menggunakan *listener* `ever(firebaseUser, ...)` setelah user terautentikasi. Mengambil data **sekali (one-time get)** dari Firestore `collection('users').doc(user.uid).get()`, lalu memetakannya ke objek observabel `Rx<UserModel> currentUser`. |
| **`controllers/profile_controller.dart`** | **Update Profil** (`updateProfile`) | Melakukan dua *update* asinkron: **1.** Memperbarui `displayName` di **Firebase Auth** (`user.updateDisplayName(name)`). **2.** Memperbarui *field* `name` di **Firestore** (`.update({'name': name})`). Data lokal `currentUser` diperbarui secara manual setelah sukses. |
| **`pages/profile_page.dart`** | **View Profil** | Menggunakan `Obx` untuk menampilkan data dari `profileC.currentUser.value`. Tombol **Edit** (Nama) memicu `_showEditNameDialog` yang kemudian memanggil `profileC.updateProfile`. Tombol **Logout** memanggil `authC.logout()`. |
| **`pages/profile_page.dart`** | **Ubah Password** (Dialog) | Fungsi `_showChangePasswordDialog()` menampilkan *form* validasi. Aksi ini memicu `authC.updatePassword` (yang kemungkinan ada di `AuthController`), memerlukan input **password saat ini** untuk *re-autentikasi* sebelum mengubah password. |
| **`pages/home_page.dart`** | **List Data Utama** | Menampilkan daftar buku dari **`bookC.books`** (sebuah `RxList`) dalam sebuah `ListView.builder`. Menggunakan `Obx` dan `RefreshIndicator` (`onRefresh: () => bookC.fetchBooks()`) untuk pembaruan data. Navigasi ke detail buku menggunakan `Get.toNamed` dengan objek `book` sebagai *argument*. |
| **`pages/statistics_page.dart`** | **Statistik Inventaris** | Menggunakan data observabel **`bookC.books`** untuk melakukan perhitungan lokal (*fold* dan *where*): Total Judul, Total Kuantitas, Total Nilai Inventaris (Stok x Harga), dan jumlah buku **Stok Menipis** (`jumlah <= 5`) dan **Stok Habis** (`jumlah == 0`). |
| **`pages/statistics_page.dart`** | **Tampilan Statistik** | Menampilkan hasil perhitungan dalam serangkaian *widget* **`_buildStatCard`** dan *Progress Bar* **`_buildStatusRow`**. Tampilan ini bersifat *reactive* karena dibungkus dalam `Obx` yang bergantung pada perubahan pada `bookC.books`. |

---
## 5. Konfigurasi Utama, Routing, dan Setup Firebase ⚙️

Bagian ini merangkum inisialisasi aplikasi, definisi rute, dan pengaturan autentikasi middleware menggunakan GetX.

| File | Fungsi Utama | Detail Implementasi & Interaksi |
| :--- | :--- | :--- |
| **`main.dart`** | **Inisialisasi Aplikasi** | Fungsi `main()` adalah *entry point* aplikasi. Ia memanggil `WidgetsFlutterBinding.ensureInitialized()` diikuti oleh **`Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`** untuk menginisialisasi Firebase di platform yang sesuai. |
| **`main.dart`** | **Inisialisasi Dependency** | Menggunakan **`Get.put()`** untuk mendaftarkan *Controller* utama (`AuthController`, `BookController`, `ProfileController`) secara permanen (*permanent dependency*) di dalam *dependency injection* GetX. |
| **`main.dart`** | **Konfigurasi GetMaterialApp** | Mengatur **Tema** aplikasi (dominan warna cokelat), **`initialRoute`** ke `AppRoutes.login`, dan mendaftarkan semua rute aplikasi dalam *list* **`getPages`**. |
| **`main.dart`** | **`AuthMiddleware`** (Pengawal Rute) | Diterapkan ke semua rute setelah Login/Register. Tugasnya: **1.** Mencegah pengguna yang **belum login** mengakses halaman terproteksi (mengarahkan ke `/login`). **2.** Mencegah pengguna yang **sudah login** kembali ke halaman `/login` atau `/register` (mengarahkan ke `/main`). |
| **`utils/app_routes.dart`** | **Definisi Nama Rute** | Berisi konstanta `static const String` untuk semua nama rute, memastikan konsistensi dan menghindari *typo* saat navigasi (e.g., `AppRoutes.main`, `AppRoutes.bookDetail`). |
| **`main.dart`** | **Penerusan Argumen Rute** | Rute dinamis seperti `AppRoutes.bookDetail` dan `AppRoutes.editBook` mengambil objek **`BookModel`** yang dilewatkan melalui `Get.arguments` saat navigasi, dan objek ini kemudian digunakan untuk inisialisasi halaman (e.g., `BookDetailPage(book: book)`). |
| **`firebase_options.dart`** | **Konfigurasi Firebase** | File yang **dibuat otomatis** oleh **FlutterFire CLI**. Berisi semua **kunci API** dan ID proyek spesifik (`projectId: 'responsi2irfan'`) untuk setiap platform (Web, Android, iOS, macOS), memungkinkan `Firebase.initializeApp` berfungsi dengan benar di mana pun aplikasi dijalankan. |

---
## 🖼️ Tampilan Aplikasi (Screenshot)

Screenshot aplikasi ditempatkan di folder `assets/images/`.

| Login | Register | Home | Edit Book |
| :---: | :---: | :---: | :---: |
| ![](/assets/images/image1.jpg) | ![](/assets/images/image2.jpg) | ![](/assets/images/image3.jpg) | ![](/assets/images/image4.jpg) |
| Detail Book | Delete Book | Add Book | Statistic |
| ![](/assets/images/image5.jpg) | ![](/assets/images/image6.jpg) | ![](/assets/images/image7.jpg) | ![](/assets/images/image8.jpg) |
| Profile | Edit Profile | Password Change | Information |
| ![](/assets/images/image9.jpg) | ![](/assets/images/image10.jpg) | ![](/assets/images/image11.jpg) | ![](/assets/images/image12.jpg) |

---
## 🎬 Video Demonstrasi Aplikasi

Lihat fungsionalitas aplikasi ini secara langsung:

▶️ ****

---

## ⚙️ Cara Menjalankan Proyek

1.  **Clone Repository:**
    ```bash
    git clone [https://github.com/IrfanRomadhonWidodo/Responsi_2_Mobile_Paket_3_H1D023023.git](https://github.com/IrfanRomadhonWidodo/Responsi_2_Mobile_Paket_3_H1D023023.git)
    cd Responsi_2_Mobile_Paket_3_H1D023023
    ```
2.  **Instal Dependensi:**
    ```bash
    flutter pub get
    ```
3.  **Konfigurasi Firebase:**
    * Pastikan proyek Firebase Anda telah disiapkan.
    * Unduh file konfigurasi **`google-services.json`** (Android) dan letakkan di `android/app/`.
    * Pastikan Anda menjalankan `flutterfire configure` (jika menggunakan FlutterFire CLI) atau pastikan file **`firebase_options.dart`** sudah benar.
4.  **Jalankan Aplikasi:**
    ```bash
    flutter run
    ```
