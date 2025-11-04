import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/transaksi_controller.dart';
import '../controllers/k_waktu_controller.dart';
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
    final waktu = Get.find<KWaktuController>();

    DateTime? eta;
    final args = Get.arguments;
    if (args is Map && args['eta'] is String) {
      try {
        eta = DateTime.parse(args['eta']);
      } catch (_) {}
    }

    return GetBuilder<TransaksiController>(
      builder: (_) {
        final list = trx.items;
        return Scaffold(
          backgroundColor: const Color(0xFFFFF8F0), 
          appBar: const HeaderWidget(title: 'Transaksi'),
          body: list.isEmpty
              ? const Center(child: Text('Belum ada transaksi'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final t = list[i];
                    return _TxCard(
                      tx: t,
                      fmtMoney: _fmtMoney,
                      waktu: waktu,
                      eta: eta, 
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
  final DateTime? eta;

  const _TxCard({
    required this.tx,
    required this.fmtMoney,
    required this.waktu,
    this.eta,
  });

  static const rose = Color(0xFFE8A0BF);

  Color _statusColor(String s) {
    final ss = s.toLowerCase();
    if (ss.contains('paid') || ss.contains('success')) {
      return const Color(0xFF2E7D32); 
    }
    if (ss.contains('pending') || ss.contains('process')) {
      return const Color(0xFFEF6C00); 
    }
    if (ss.contains('cancel') || ss.contains('failed')) {
      return const Color(0xFFC62828); 
    }
    return Colors.black87; 
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(tx.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12.withOpacity(.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
  
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(.25)),
                ),
                child: Text(
                  tx.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.event_outlined, size: 16, color: Colors.black54),
              const SizedBox(width: 6),
              Text(
                waktu.formatDate(tx.createdAt),
                style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 10),

      
          Row(
            children: [
              const Icon(Icons.payments_outlined, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  tx.paymentMethod,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.local_shipping_outlined, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  tx.shipping,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),


          if (eta != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: rose.withOpacity(.35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule_outlined, size: 16, color: rose),
                      const SizedBox(width: 6),
                      Text(
                        'Perkiraan tiba: ${DateFormat("EEE, dd MMM yyyy • HH:mm").format(eta!)}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 12),

     
          ...tx.items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 7),
                      decoration: const BoxDecoration(
                        color: rose,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    
                    Expanded(
                      child: Text(
                        e.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                
                    Text(
                      'x${e.qty}',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 10),

          Container(
            height: 1,
            color: Colors.black12.withOpacity(.10),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Text(
                'Total: ${fmtMoney(tx.total, tx.currency)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: rose,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
