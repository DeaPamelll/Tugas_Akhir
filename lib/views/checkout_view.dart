// lib/views/checkout_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/cart_controller.dart';
import '../controllers/k_mata_uang_controller.dart';
import '../controllers/transaksi_controller.dart';
import '../models/cart_item.dart';
import '../services/notification_service.dart';
import 'transaksi_view.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  final cart = Get.find<CartController>();
  final curr = Get.find<KMataUangController>();
  final trx  = Get.find<TransaksiController>();

  String payment = 'Transfer Bank';
  String shipping = 'JNE';

  String formatMoney(num v, String code) {
    final f = NumberFormat.currency(symbol: '$code ', decimalDigits: 2);
    return f.format(v);
  }

  @override
  Widget build(BuildContext context) {
    final selected = cart.selectedItems; // snapshot item terpilih
    if (selected.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(child: Text('Tidak ada item terpilih')),
      );
    }

    final fx = curr.factorFromUsdTo(curr.selected.value);
    final totalUsd = cart.selectedTotal;
    final totalFx  = totalUsd * fx;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 140),
        children: [
          const Text('Ringkasan', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          ...selected.map((it) => ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(it.thumbnail, width: 56, height: 56, fit: BoxFit.cover),
                ),
                title: Text(it.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('Qty: ${it.qty}  •  ${formatMoney(it.price * fx, curr.selected.value)}'),
                trailing: Text(formatMoney(it.subTotal * fx, curr.selected.value),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              )),
          const Divider(height: 24),
          Row(
            children: [
              const Text('Metode Pembayaran'),
              const Spacer(),
              DropdownButton<String>(
                value: payment,
                items: const [
                  DropdownMenuItem(value: 'Transfer Bank', child: Text('Transfer Bank')),
                  DropdownMenuItem(value: 'E-Wallet', child: Text('E-Wallet')),
                  DropdownMenuItem(value: 'COD', child: Text('COD')),
                ],
                onChanged: (v) => setState(() => payment = v ?? payment),
              ),
            ],
          ),
          Row(
            children: [
              const Text('Ekspedisi'),
              const Spacer(),
              DropdownButton<String>(
                value: shipping,
                items: const [
                  DropdownMenuItem(value: 'JNE', child: Text('JNE')),
                  DropdownMenuItem(value: 'SiCepat', child: Text('SiCepat')),
                  DropdownMenuItem(value: 'Pos', child: Text('Pos Indonesia')),
                ],
                onChanged: (v) => setState(() => shipping = v ?? shipping),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Total', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text(
                formatMoney(totalFx, curr.selected.value),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE8A0BF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                try {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Konfirmasi Pembayaran'),
                      content: Text('Bayar ${formatMoney(totalFx, curr.selected.value)} sekarang?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                        ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Bayar')),
                      ],
                    ),
                  );
                  if (confirmed != true) return;

                  // 1) Simpan transaksi
                  await trx.recordPayment(
                    items: List<CartItem>.from(cart.selectedItems),
                    total: totalFx,
                    currency: curr.selected.value,
                    paymentMethod: payment,
                    shipping: shipping,
                  );

                  // 2) Hapus item terpilih
                  cart.removeSelected();

                  // 3) Notifikasi
                  await NotificationService.showSuccess(
                    'Pembayaran Berhasil',
                    'Total: ${formatMoney(totalFx, curr.selected.value)}',
                  );

                  // 4) Pindah ke transaksi
                  Get.offAll(() => const TransaksiView());
                } catch (e, st) {
                  debugPrint('[CHECKOUT][ERROR] $e\n$st');
                  Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
                }
              },

              child: const Text('Bayar Sekarang', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
