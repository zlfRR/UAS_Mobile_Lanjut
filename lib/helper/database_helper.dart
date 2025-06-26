import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/endemik.dart';


class DatabaseHelper {
  static const _databaseName = 'my_database.db';
  static const _databaseVersion = 1;
  static const _tableName = 'endemik';
  static const _columnId = 'id';
  static const _columnNama = 'nama';
  static const _columnNamaLatin = 'nama_latin';
  static const _columnDeskripsi = 'deskripsi';
  static const _columnAsal = 'asal';
  static const _columnFoto = 'foto';
  static const _columnStatus = 'status';
  static const _columnIsFavorit = 'is_favorit';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  Future _initDatabase() async {
    final databasesPath = await
    getApplicationDocumentsDirectory();
    final path = join(databasesPath.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion,
        onCreate: _onCreate);
  }

  // membuat tabel
  Future _onCreate(Database db, int version) async {
    // _columnId bukan integer dan bukan auto increment
    // _columnIsFavorit
    await db.execute('''
    CREATE TABLE $_tableName (
    $_columnId TEXT PRIMARY KEY,
    $_columnNama TEXT,
    $_columnNamaLatin TEXT,
    $_columnDeskripsi TEXT,
    $_columnAsal TEXT,
    $_columnFoto TEXT,
    $_columnStatus TEXT,
    $_columnIsFavorit TEXT)
    ''');
  }

  // menyimpan data
  Future<int> insert(Endemik object) async {
    final db = await database;

    return await db.insert(_tableName, object.toMap());
  }

  // mengambil seluruh data
  Future<List<Endemik>> getAll() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    return List.generate(maps.length, (i) {
      return Endemik.fromMap(maps[i]);
    });
  }

  // menandai atau menghapus data sebagai favorit
  Future<int> setFavorit(String id, String isFavorit) async {
    final db = await database;

    // Update hanya kolom favorit
    return await db.update(
      _tableName,
      { _columnIsFavorit: isFavorit },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // mengambil data yang ditandai sebagai favorit
  // is_favorit = true
  Future<List<Endemik>> getFavoritAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnIsFavorit = ?',
      whereArgs: ["true"],
    );

    return maps.map((map) => Endemik.fromMap(map)).toList();
  }

  // menampilkan data berdasarkan ID
  Future<Endemik?> getById(String id) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return null;
    }

    return Endemik.fromMap(maps.first);
  }

  // -- tidak digunakan --
  // mengubah data endemik
  Future<int> updateEndemik(Endemik object) async {
    final db = await database;
    return await db.update(_tableName, object.toMap(), where:
    '$_columnId = ?', whereArgs: [object.id]);
  }

  // mengubah seluruh isi kolom is_favorit menjadi false
  Future<int> deleteFavoritAll() async {
    final db = await database;
    return await db.update(
      _tableName,
      { _columnIsFavorit: false },
    );
  }

  // -- tidak digunakan --
  // menghapus data
  Future<int> delete(String id) async {
    final db = await database;
    return await db.delete(_tableName, where: '$_columnId = ?',
        whereArgs: [id]);
  }

  // menghitung jumlah data dalam tabel
  Future<int> count() async {
    final db = await database;
    var result = await db.rawQuery('SELECT COUNT(*) FROM $_tableName');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }
}