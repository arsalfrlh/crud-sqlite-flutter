class Barang {
  int? id;
  String gambar;
  String namaBarang;
  int harga;

  Barang({this.id, required this.gambar, required this.namaBarang, required this.harga});

  factory Barang.fromDatabase(Map<String, dynamic> data){
    return Barang(
      id: data['id'],
      gambar: data['gambar'],
      namaBarang: data['nama_barang'],
      harga: data['harga'],
    );
  }

  Map<String, dynamic> toDatabase(){
    return{
      'id': id,
      'gambar': gambar,
      'nama_barang': namaBarang,
      'harga': harga,
    };
  }
}
