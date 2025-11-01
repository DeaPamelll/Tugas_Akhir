import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/transaksi_controller.dart';
import '../controllers/k_waktu_controller.dart'; // ⬅️ Tambah ini
import '../models/transaction_model.dart';
import 'widgets/footer_widget.dart';
import 'widgets/header_widget.dart';

class TransaksiView extends StatelessWidget {
  const TransaksiView({super.key});

  String _fmtMoney(double v, String code) =>
      NumberFormat.currency(symbol: '$code ', decimalDigits: 2).format(v);

  @override
  Widget build(BuildContext context) {
    final trx = Get.find<TransaksiController>();
    final waktu = Get.find<KWaktuController>(); // ambil controller waktu

    return GetBuilder<TransaksiController>(
      builder: (_) {
        final list = trx.items; // sudah ter-filter per user
        return Scaffold(
          appBar: const HeaderWidget(title: 'Transaksi'),
          body: list.isEmpty
              ? const Center(child: Text('Belum ada transaksi'))
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final t = list[i];
                    return _TxCard(
                      tx: t,
                      fmtMoney: _fmtMoney,
                      waktu: waktu, // kirim controller waktu ke card
                    );
                  },
                ),
          bottomNavigationBar: const FooterWidget(currentIndex: 1),
        );
      },
    );
  }
}

class _TxCard extends StatelessWidget {
  final TransactionModel tx;
  final String Function(double, String) fmtMoney;
  final KWaktuController waktu;

  const _TxCard({
    required this.tx,
    required this.fmtMoney,
    required this.waktu,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status: ${tx.status}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),

            // Gunakan format waktu sesuai zona pilihan
            Text('Tanggal: ${waktu.formatDate(tx.createdAt)}'),
            const SizedBox(height: 4),

            Text('Pembayaran: ${tx.paymentMethod} • Ekspedisi: ${tx.shipping}'),
            const Divider(height: 18),

            ...tx.items.map((e) => Row(
                  children: [
                    Text('${e.qty}x', style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                Text(
                  'Total: ${fmtMoney(tx.total, tx.currency)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
