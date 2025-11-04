import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';
import 'register_view.dart';

class LandingView extends StatelessWidget {
  LandingView({super.key});

  final Color primaryPink = const Color(0xFFE8A0BF); // Pink pekat untuk BG
  final Color lightPinkIcon = const Color.fromARGB(255, 249, 249, 249); // Pink muda untuk ikon
  final Color whiteColor = Colors.white;

  // 2. Definisikan ukuran untuk icon circle agar konsisten
  final double iconCircleRadius = 60.0;
  
  // 3. Definisikan di mana lengkungan dimulai (35% dari atas layar)
  final double waveStartFraction = 0.35;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Hitung posisi Y (vertikal) di mana lengkungan dimulai
    final double waveStartY = screenHeight * waveStartFraction;

    return Scaffold(
      backgroundColor: whiteColor, // Latar belakang atas (putih)
      body: Stack(
        children: [
          // --- BAGIAN 1: Latar Belakang Pink Melengkung ---
          ClipPath(
            clipper: BottomWaveClipper(
              waveStartFraction: waveStartFraction,
              waveCurveHeight: 80.0, // Sesuaikan kedalaman lengkungan di sini
            ),
            child: Container(
              color: primaryPink,
              height: screenHeight,
              width: screenWidth,
            ),
          ),

          // --- BAGIAN 2: Konten Utama (Teks & Tombol) ---
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Spacer untuk memberi ruang bagi ikon yang diposisikan di atas
                        SizedBox(height: waveStartY + iconCircleRadius - 20),

                        
                        Text(
                          "D’Verse",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: whiteColor, 
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Your universe of shopping!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: whiteColor.withOpacity(0.85),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 48),

                        // Tombol Login (sudah ada, di-restyle)
                        ElevatedButton(
                          onPressed: () => Get.to(() => LoginView()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: primaryPink, // Teks warna pink
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tombol Register (sudah ada, di-restyle)
                        OutlinedButton(
                          onPressed: () => Get.to(() => RegisterView()),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: whiteColor, width: 2),
                            foregroundColor: whiteColor,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Daftar Sekarang",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(), // Mendorong copyright ke bawah


                        Text(
                          "© 2025 D'Verse",
                          style: TextStyle(
                              color: whiteColor.withOpacity(0.7), fontSize: 12),
                        ),
                        const SizedBox(height: 20), // Padding bawah
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- BAGIAN 3: Ikon di Tengah Lengkungan ---
          Positioned(
            top: waveStartY - iconCircleRadius,
            left: (screenWidth / 2) - iconCircleRadius,
            child: Container(
              width: iconCircleRadius * 2,
              height: iconCircleRadius * 2,
              decoration: BoxDecoration(
                color: primaryPink, 
                shape: BoxShape.circle,
                border: Border.all(color: whiteColor, width: 5), 
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Icon(
                Icons.shopping_bag_rounded, // Ikon dari kode Anda
                size: iconCircleRadius, // Ukuran ikon disesuaikan
                color: lightPinkIcon, // Warna ikon pink muda
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Class CustomClipper untuk membuat lengkungan ---
// (Letakkan class ini di file yang sama, di luar class LandingView)
class BottomWaveClipper extends CustomClipper<Path> {
  final double waveStartFraction;
  final double waveCurveHeight;

  BottomWaveClipper({
    required this.waveStartFraction,
    required this.waveCurveHeight,
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    final double waveStartY = size.height * waveStartFraction;

    // Mulai dari kiri, di posisi Y awal lengkungan
    path.moveTo(0, waveStartY);

    // Membuat lengkungan parabola sederhana
    path.quadraticBezierTo(
      size.width / 2, // Titik kontrol X (tengah)
      waveStartY + waveCurveHeight, // Titik kontrol Y (puncak lengkungan)
      size.width, // Titik akhir X (kanan)
      waveStartY, // Titik akhir Y (sama dengan awal)
    );

    path.lineTo(size.width, size.height); // Garis ke pojok kanan bawah
    path.lineTo(0, size.height); // Garis ke pojok kiri bawah
    path.close(); // Tutup path

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}