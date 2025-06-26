import 'package:flutter/material.dart';
import 'package:mobile_lanjut_uas/screen/home_screen.dart';
import 'package:mobile_lanjut_uas/service/endemik_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadDataAndNavigate();
  }

  Future<void> _loadDataAndNavigate() async {
    // Memuat data dari service
    await EndemikService().getData();

    // Tunggu beberapa saat untuk efek splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Pindah ke HomeScreen setelah data dimuat
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Anda bisa menambahkan logo seperti di video
            // Icon(Icons.pets, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Memuat Data Endemik...',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}