import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/book_controller.dart';
import '../models/book_model.dart';

class EditBookPage extends StatefulWidget {
  final BookModel book;

  const EditBookPage({super.key, required this.book});

  @override
  State<EditBookPage> createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final bookC = Get.find<BookController>();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController judulC;
  late final TextEditingController hargaC;
  late final TextEditingController jumlahC;
  late final TextEditingController tanggalMasukC;
  late final TextEditingController volumeC;
  late final TextEditingController penulisC;
  late final TextEditingController penerbitC;

  @override
  void initState() {
    super.initState();
    judulC = TextEditingController(text: widget.book.judul);
    hargaC = TextEditingController(text: widget.book.harga.toString());
    jumlahC = TextEditingController(text: widget.book.jumlah.toString());
    tanggalMasukC = TextEditingController(text: widget.book.tanggalMasuk);
    volumeC = TextEditingController(text: widget.book.volume.toString());
    penulisC = TextEditingController(text: widget.book.penulis);
    penerbitC = TextEditingController(text: widget.book.penerbit);
  }

  @override
  void dispose() {
    judulC.dispose();
    hargaC.dispose();
    jumlahC.dispose();
    tanggalMasukC.dispose();
    volumeC.dispose();
    penulisC.dispose();
    penerbitC.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        tanggalMasukC.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Inventaris Irfan")),
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Judul
                        TextFormField(
                          controller: judulC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Judul tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Judul Buku",
                            prefixIcon: Icon(Icons.book),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Penulis
                        TextFormField(
                          controller: penulisC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Penulis tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Penulis",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Penerbit
                        TextFormField(
                          controller: penerbitC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Penerbit tidak boleh kosong';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Penerbit",
                            prefixIcon: Icon(Icons.business),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Harga
                        TextFormField(
                          controller: hargaC,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Harga tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Harga harus berupa angka';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Harga",
                            prefixIcon: Icon(Icons.money),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Jumlah
                        TextFormField(
                          controller: jumlahC,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Jumlah tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Jumlah harus berupa angka';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Jumlah",
                            prefixIcon: Icon(Icons.inventory_2),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Volume
                        TextFormField(
                          controller: volumeC,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Volume tidak boleh kosong';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Volume harus berupa angka';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: "Volume",
                            prefixIcon: Icon(Icons.archive),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tanggal Masuk
                        TextFormField(
                          controller: tanggalMasukC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal masuk tidak boleh kosong';
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: const InputDecoration(
                            labelText: "Tanggal Masuk",
                            prefixIcon: Icon(Icons.calendar_today),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Tombol Simpan
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: bookC.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                final book = BookModel(
                                  id: widget.book.id,
                                  judul: judulC.text,
                                  harga: int.parse(hargaC.text),
                                  jumlah: int.parse(jumlahC.text),
                                  tanggalMasuk: tanggalMasukC.text,
                                  volume: int.parse(volumeC.text),
                                  penulis: penulisC.text,
                                  penerbit: penerbitC.text,
                                );
                                bookC.updateBook(widget.book.id!, book);
                              }
                            },
                      child: bookC.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Update"),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
