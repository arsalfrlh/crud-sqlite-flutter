class Barang {
  int? id;
  String gambar;
  String namaBarang;
  int stok;

  Barang({ this.id, required this.gambar, required this.namaBarang, required this.stok});

  factory Barang.fromDatabase(Map<String, dynamic> data){
    return Barang(
      id: data['id'],
      gambar: data['gambar'],
      namaBarang: data['nama_barang'],
      stok: data['stok'],
    );
  }

  Map<String, dynamic> toDatabase(){
    return{
      'id': id,
      'gambar': gambar,
      'nama_barang': namaBarang,
      'stok': stok,
    };
  }
}
