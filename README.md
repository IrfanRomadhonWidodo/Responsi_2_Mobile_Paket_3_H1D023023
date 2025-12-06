# 📚 E-Library Manager: Aplikasi Manajemen Buku Berbasis Firebase

## 💻 Project Responsi II Mobile Programming (Paket 3)

Aplikasi mobile ini dikembangkan menggunakan **[Sebutkan Framework/Bahasa Anda, contoh: Flutter/Dart]** dan mengimplementasikan arsitektur **Model-View-Controller (MVC)** untuk mengelola data buku dan pengguna secara efisien. Seluruh operasi data ditangani secara *real-time* menggunakan layanan **Google Firebase**.

---

## 👨‍🎓 Informasi Pengembang

| Kategori | Detail |
| :--- | :--- |
| **Nama Lengkap** | **Irfan Romadhon Widodo** |
| **NIM** | **H1D023023** |
| **Asal Institusi** | **[NAMA UNIVERSITAS/INSTITUSI ANDA]** |
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
### 🛠️ Spesifikasi Layanan Backend (API)

Aplikasi ini menggunakan **Google Firebase** untuk tiga layanan utama:

1.  **Firebase Authentication:** Mengelola otentikasi pengguna (Login/Register).
2.  **Cloud Firestore:** Basis data NoSQL untuk menyimpan data `BookModel` dan `UserModel`.
3.  **Firebase Storage:** **[Sebutkan 'Digunakan' jika menyimpan gambar, atau 'Tidak Digunakan']**.

---

## 📖 Penjelasan Kode Detail per Fungsi

Penjelasan ini berfokus pada bagaimana logika bisnis di **`controllers/`** berinteraksi dengan Firebase untuk mencapai fungsionalitas aplikasi.

### 1. Otentikasi Pengguna (Firebase Auth)

| File | Fungsi Utama | Snippet & Penjelasan |
| :--- | :--- | :--- |
| **`controllers/auth_controller.dart`** | **Registrasi** | Menggunakan `FirebaseAuth.instance.createUserWithEmailAndPassword()`. Setelah berhasil, menyimpan data `UserModel` awal ke koleksi `users` di Firestore. |
| **`controllers/auth_controller.dart`** | **Login** | Menggunakan `FirebaseAuth.instance.signInWithEmailAndPassword()` untuk memverifikasi kredensial pengguna. |
| **`pages/auth/login_page.dart`** | **View Login** | Memicu fungsi login pada `AuthController` dan mengarahkan pengguna ke `HomePage` setelah berhasil. |

### 2. Manajemen Buku (CRUD - Cloud Firestore)

Semua fungsi di bawah ini terletak di **`controllers/book_controller.dart`**.

| Fungsi CRUD | Detail Implementasi Kode |
| :--- | :--- |
| **C**reate (`addBook`) | Memanggil `FirebaseFirestore.instance.collection('books').add(bookModel.toJson())`. Data buku dikonversi dari `BookModel` ke format Map menggunakan `toJson()` sebelum disimpan. |
| **R**ead (`fetchBooks`) | Menggunakan **`.snapshots()`** pada koleksi `books` untuk mendapatkan `Stream<QuerySnapshot>`. Data stream ini diproses di **`pages/home_page.dart`** menggunakan `StreamBuilder` dan dikonversi kembali menjadi `List<BookModel>`. |
| **U**pdate (`updateBook`) | Memanggil `collection('books').doc(documentId).update(newData)`. Memastikan pembaruan hanya terjadi pada dokumen yang ditargetkan menggunakan `documentId` yang diperoleh saat membaca data. |
| **D**elete (`deleteBook`) | Memanggil `collection('books').doc(documentId).delete()`. Fungsi ini membersihkan dokumen buku secara permanen dari basis data. |

### 3. Model Data & Konversi

| File | Fungsi Utama | Snippet & Penjelasan |
| :--- | :--- | :--- |
| **`models/book_model.dart`** | **Konversi Data** | Wajib memiliki *factory constructor* `BookModel.fromFirestore(DocumentSnapshot doc)` untuk memetakan data dari Firestore ke objek Dart, dan metode `toJson()` untuk memetakan objek Dart kembali ke format Map yang diterima Firestore. |
| **`models/user_model.dart`** | **Struktur Pengguna** | Mendefinisikan *field* pengguna (`uid`, `name`, `email`) dan menyertakan metode `fromJson`/`toJson` untuk interaksi dengan koleksi `users` di Firestore, yang biasanya dibuat saat pendaftaran. |

---

## 🎬 Video Demonstrasi Aplikasi

Lihat fungsionalitas aplikasi ini secara langsung:

▶️ **[LINK VIDEO DEMO ANDA]**

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
