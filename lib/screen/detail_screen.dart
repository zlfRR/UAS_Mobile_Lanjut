import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:mobile_lanjut_uas/helper/database_helper.dart';
import 'package:mobile_lanjut_uas/model/endemik.dart';

class DetailScreen extends StatefulWidget {
  final Endemik endemik;
  const DetailScreen({super.key, required this.endemik});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFavorit;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _isFavorit = widget.endemik.is_favorit == "true";
  }

  void _toggleFavorit() async {
    setState(() {
      _isFavorit = !_isFavorit;
    });

    await _dbHelper.setFavorit(widget.endemik.id, _isFavorit.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorit
              ? '${widget.endemik.nama} ditambahkan ke favorit'
              : '${widget.endemik.nama} dihapus dari favorit',
        ),
      ),
    );
  }

  Color getAppBarColor(String status) {
    String statusLower = status.toLowerCase();

    if (statusLower == 'aman') {
      return Colors.green;
    } else if (statusLower == 'rentan' || statusLower.contains('terancam')) {
      return Colors.orange.shade800;
    } else if (statusLower == 'kritis') {
      return Colors.red.shade800;
    } else {
      return Theme.of(context).primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endemik.nama),
        backgroundColor: getAppBarColor(widget.endemik.status),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorit ? Icons.favorite : Icons.favorite_border,
              color: _isFavorit ? Colors.white : null,
            ),
            onPressed: _toggleFavorit,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                // --- PERUBAHAN DI SINI ---
                // onTap sekarang membuka widget FullScreenImageViewer yang baru
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return FullScreenImageViewer(
                      imageUrl: widget.endemik.foto,
                      heroTag: widget.endemik.id,
                    );
                  }));
                },
                child: Hero(
                  tag: widget.endemik.id,
                  child: Image.network(
                    widget.endemik.foto,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.endemik.nama,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.endemik.nama_latin,
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.endemik.deskripsi,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              Text(
                'Asal: ${widget.endemik.asal}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Status Konservasi: ${widget.endemik.status}',
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// --- WIDGET BARU UNTUK TAMPILAN ZOOM ---

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Layer 1: Gambar yang bisa di-zoom
          PhotoView(
            imageProvider: NetworkImage(imageUrl),
            heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.5,
          ),

          // Layer 2: Tombol Kembali
          Positioned(
            top: 50.0,
            left: 16.0,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.6),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}