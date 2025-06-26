class Endemik {
  final String id;
  final String nama;
  final String nama_latin;
  final String deskripsi;
  final String asal;
  final String foto;
  final String status;
  final String is_favorit;

  Endemik({
    required this.id,
    required this.nama,
    required this.nama_latin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    required this.status,
    required this.is_favorit,
  });

  // Untuk konversi dari JSON API
  factory Endemik.fromJson(Map<String, dynamic> json) {
    return Endemik(
      id: json['id'],
      nama: json['nama'],
      nama_latin: json['nama_latin'],
      deskripsi: json['deskripsi'],
      asal: json['asal'],
      foto: json['foto'],
      status: json['status'],
      is_favorit: "false", // Default value saat pertama kali fetch dari API
    );
  }

  // Untuk konversi dari Map Database (SQFLite)
  factory Endemik.fromMap(Map<String, dynamic> map) {
    return Endemik(
      id: map['id'],
      nama: map['nama'],
      nama_latin: map['nama_latin'],
      deskripsi: map['deskripsi'],
      asal: map['asal'],
      foto: map['foto'],
      status: map['status'],
      is_favorit: map['is_favorit'],
    );
  }

  // Untuk konversi ke Map Database (SQFLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nama_latin': nama_latin,
      'deskripsi': deskripsi,
      'asal': asal,
      'foto': foto,
      'status': status,
      'is_favorit': is_favorit,
    };
  }
}