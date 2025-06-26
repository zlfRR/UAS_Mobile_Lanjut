import 'package:dio/dio.dart';
import '../model/endemik.dart';
import '../helper/database_helper.dart';

/*
  service ini dibentuk karena prosesnya yang akan memblokir memory UI
  sehingga perlu dipisah untuk tiap proses "mengambil data"
  yang pastinya membutuhkan waktu lama
*/

class EndemikService {
  final Dio _dio = Dio();

  Future<bool> isDataAvailable() async {
    final dbHelper = DatabaseHelper();
    final int count = await dbHelper.count();
    return count > 0;
  }

  Future<List<Endemik>> getData() async {
    final dbHelper = DatabaseHelper();

    try {
      // Cek apakah data sudah ada di database
      bool dataExists = await isDataAvailable();
      if (dataExists) {
        print("Data sudah ada di database, tidak perlu mengambil dari API.");
        final List<Endemik> oldData = await dbHelper.getAll();
        return oldData;
      }

      // jika belum, maka tarik dari API
      final response = await _dio
          .get('https://hendroprwk08.github.io/data_endemik/endemik.json');
      final List<dynamic> data = response.data;

      for (var json in data) {
        Endemik model = Endemik(
            id: json["id"],
            nama: json["nama"],
            nama_latin: json["nama_latin"],
            deskripsi: json["deskripsi"],
            asal: json["asal"],
            foto: json["foto"],
            status: json["status"],
            is_favorit: "false" ); // masuk sebagai string

        await dbHelper.insert(model);
      }

      return data.map((json) => Endemik.fromJson(json)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Endemik>> getFavoritData() async {
    try {
        final db = await DatabaseHelper();
        final List<Endemik> data = await db.getFavoritAll();
        return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
