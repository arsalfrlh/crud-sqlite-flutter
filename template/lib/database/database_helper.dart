import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:templatesqlite/models/barang.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal(); //membuat instance singleton dari class DatabaseHelper| static berarti properti ini milik class, bukan objek.| memanggil constructor internal yang ada di bawah.
  factory DatabaseHelper() => instance; //factory constructor, yaitu konstruktor khusus yang tidak selalu membuat objek baru, tapi bisa mengembalikan objek yang sudah ada.| setiap kali DatabaseHelper() dipanggil, dia akan mengembalikan objek instance yang sudah dibuat sebelumnya.| Tujuannya agar hanya ada satu instance dari DatabaseHelper (pola desain Singleton).

  DatabaseHelper.internal(); //named constructor yang digunakan hanya secara internal untuk membuat objek sekali saja. dgunakn utk membuat database saat peryama kali buka aplikasi 
  static Database? _database; //Digunakan untuk menyimpan koneksi database.| Biasanya nanti akan diinisialisasi(dibuat) sekali lalu digunakan berulang kali

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'barang.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE barang(id INTEGER PRIMARY KEY AUTOINCREMENT, gambar TEXT, nama_barang TEXT, stok INTEGER)',
        );
      },
    );
  }

  Future<List<Barang>> getBarang() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query('barang');
    return List.generate(data.length, (i) {
      return Barang.fromDatabase(data[i]);
    });
  }

  Future<void> addBarang(Barang barang) async {
    final db = await database;
    await db.insert('barang', barang.toDatabase());
  }

  Future<void> updateBarang(Barang barang, int id) async {
    final db = await database;
    await db.update('barang', barang.toDatabase(), where: 'id = $id');
  }

  Future<void> deleteBarang(int id) async {
    final db = await database;
    await db.delete('barang', where: 'id = $id');
  }
}
