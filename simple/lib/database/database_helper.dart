import 'package:crudsqlite/models/barang.dart';
import 'package:sqflite/sqflite.dart'; //import sqflite
import 'package:path/path.dart'; //import path databse| lokasi database

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal(); //konfigurasi class ini
  factory DatabaseHelper() => instance; //konfigurasi class ini

  DatabaseHelper.internal();

  static Database? _database; //databse boleh null di simpan dibariabel ini

  Future<Database> get database async { //menyimpan database di variabel ini yg berisi mengembalikan variabel _database tdi
    if (_database != null) return _database!; //jika variabel databse tidak null akan mengembalikan variabel _databse dgn tanda !| tdk null
    _database = await initDB(); //jika databsenya null akan memanggil function initDB() dan mengembalikan database dgn tanda !| tdk null
    return database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'barangs.db'); //variabel path ini akan membuat database dan lokasi dgn nama "barangs" dan db "databse"
    return await openDatabase(
      path, //variabel databse dan lokasi yg tdi
      version: 1, //versi databse
      onCreate: (db, version) { 
        return db.execute(
          'CREATE TABLE barangs(id INTEGER PRIMARY KEY AUTOINCREMENT, gambar TEXT, nama_barang TEXT, harga INTEGER)', //membuat tabel beserta fieldnya
        );
      },
    );
  }

  Future<List<Barang>> getBarang() async {
    final db = await database; //menyimpan database yg di function tdi kedalam variabel db
    final List<Map<String, dynamic>> data = await db.query('barangs'); //query utk membaca tabel barangs| SELECT * FROM| (gambar,nama_barang,harga) di simpan di tipe data String, (isi gambar,isi nama_barang,isi harga) di simpan di tipe data dynamic
    return List.generate(data.length, (i) { //mengembalikan panjang data yg di tabel tdi menjadi List
      return Barang.fromDatabase(data[i]); //mengmbalikan konversi List tdi ke model barang dan function fromDatabase
    });
  }

  Future<void> addBarang(Barang barang) async {
    final db = await database; //jika tidak disimpan kedalm variabel databsenya tidak bisa menggunakan query karna databasenya masih di simpan di function Future
    await db.insert('barangs', barang.toDatabase()); //query utk menambahkan data ke tabel barangs| INSERT INTO barangs
  }

  Future<void> deleteBarang(int id)async{
    final db = await database;
    await db.delete('barangs', where: 'id = $id'); //query utk menghapus data dri tabel barangs| DELETE FROM barangs WHERE id
  }

  Future<void> updateBarang(Barang barang, int id)async{ //utk update harus lengkap mengisi modelnya
    final db = await database;
    await db.update('barangs', barang.toDatabase(), where: 'id = $id'); //query utk mengupdate data dti tabel barangs| UPDATE value WHERE id| isi updatenya dari model barang dan function toDatabase
  }
}
