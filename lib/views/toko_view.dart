import 'package:flutter/material.dart';
import 'widgets/header_widget.dart';

class TokoView extends StatelessWidget {
  const TokoView({super.key});

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
