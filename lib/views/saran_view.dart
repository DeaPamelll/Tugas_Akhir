import 'package:flutter/material.dart';
import 'widgets/header_widget.dart';

class SaranView extends StatelessWidget {
  const SaranView({super.key});

  @override
  Widget build(BuildContext context) {
    final saranController = TextEditingController();

    return Scaffold(
      appBar: const HeaderWidget(title: 'Saran & Masukan'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Kami sangat menghargai pendapat Anda!',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: saranController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis saran Anda di sini...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (saranController.text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Terima kasih atas sarannya!')),
                  );
                  saranController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8A0BF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kirim'),
            ),
          ],
        ),
      ),
    );
  }
}
