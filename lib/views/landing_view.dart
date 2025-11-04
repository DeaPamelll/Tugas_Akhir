import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_view.dart';
import 'register_view.dart';

class LandingView extends StatelessWidget {
  LandingView({super.key});

  final Color primaryPink = const Color(0xFFE8A0BF);
  final Color lightPinkIcon = const Color.fromARGB(255, 249, 249, 249);
  final Color whiteColor = Colors.white;

  final double iconCircleRadius = 60.0;
  final double waveStartFraction = 0.35;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final double waveStartY = screenHeight * waveStartFraction;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Stack(
        children: [
          ClipPath(
            clipper: BottomWaveClipper(
              waveStartFraction: waveStartFraction,
              waveCurveHeight: 80.0,
            ),
            child: Container(
              color: primaryPink,
              height: screenHeight,
              width: screenWidth,
            ),
          ),
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
                        ElevatedButton(
                          onPressed: () => Get.to(() => LoginView()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: primaryPink,
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
                        const Spacer(),
                        Text(
                          "© 2025 D'Verse",
                          style: TextStyle(
                              color: whiteColor.withOpacity(0.7), fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
                Icons.shopping_bag_rounded,
                size: iconCircleRadius,
                color: lightPinkIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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

    path.moveTo(0, waveStartY);
    path.quadraticBezierTo(
      size.width / 2,
      waveStartY + waveCurveHeight,
      size.width,
      waveStartY,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
