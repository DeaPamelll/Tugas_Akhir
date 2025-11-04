import 'package:flutter/material.dart';

class SaranView extends StatelessWidget {
  const SaranView({super.key});

  static const rose = Color(0xFFE8A0BF);
  static const lightBg = Color(0xFFFFF8F9);
  static const card = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: card,
        surfaceTintColor: card,
        elevation: 0.5,
        title: const Text(
          'Kesan & Pesan',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black12.withOpacity(.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Center(
                child: Icon(Icons.favorite_rounded,
                    size: 50, color: rose),
              ),
              SizedBox(height: 16),
              Text(
                'Kesan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: rose,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Selama mengikuti perkuliahan Mobile , saya merasa sangat senang '
                'karena mendapatkan banyak pengetahuan  tentang bagaimana membangun aplikasi '
                'mobile secara langsung menggunakan Flutter. Setiap pertemuan memberikan pengalaman '
                ' yang membuat saya semakin semangat untuk mengerjakan adar cepat selesai hehe ',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.6, fontSize: 14.5),
              ),
              SizedBox(height: 20),
              Text(
                'Pesan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: rose,
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Semoga ke depannya mata kuliah Mobile dapat terus dikembangkan '
                'dengan proyek-proyek yang lebih menantang, dengan UTS dan UAS 100 soal  ',
                textAlign: TextAlign.justify,
                style: TextStyle(height: 1.6, fontSize: 14.5),
              ),
              SizedBox(height: 20),
              Divider(),
              Center(
                child: Text(
                  '— Terima kasih atas ilmu dan bimbingannya —',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
