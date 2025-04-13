import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:templatesqlite/models/barang.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.internal();
  factory DatabaseHelper() => instance;

  DatabaseHelper.internal();
  static Database? _database;

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
