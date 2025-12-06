class BookModel {
  String? id;
  String judul;
  int harga;
  int jumlah;
  String tanggalMasuk;
  int volume;
  String penulis;
  String penerbit;

  BookModel({
    this.id,
    required this.judul,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.volume,
    required this.penulis,
    required this.penerbit,
  });

  Map<String, dynamic> toMap() {
    return {
      'judul': judul,
      'harga': harga,
      'jumlah': jumlah,
      'tanggalMasuk': tanggalMasuk,
      'volume': volume,
      'penulis': penulis,
      'penerbit': penerbit,
    };
  }

  factory BookModel.fromMap(String id, Map<String, dynamic> map) {
    return BookModel(
      id: id,
      judul: map['judul'] ?? '',
      harga: map['harga'] ?? 0,
      jumlah: map['jumlah'] ?? 0,
      tanggalMasuk: map['tanggalMasuk'] ?? '',
      volume: map['volume'] ?? 0,
      penulis: map['penulis'] ?? '',
      penerbit: map['penerbit'] ?? '',
    );
  }
}
