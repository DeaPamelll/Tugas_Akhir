import 'package:flutter/material.dart';
import 'widgets/header_widget.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HeaderWidget(title: 'Toko Kami'),
      body: Center(
        child: Text('Informasi lokasi toko dan layanan berbasis lokasi (LBS) akan ditampilkan di sini.'),
      ),
    );
  }
}
