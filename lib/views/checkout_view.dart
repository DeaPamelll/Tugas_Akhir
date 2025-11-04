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

  // Palet sederhana
  static const rose  = Color(0xFFE8A0BF);
  static final page  = Colors.grey.shade50;
  static const card  = Colors.white;

  // ==== Payment (radio) ====
  final List<_PaymentOpt> _payments = const [
    _PaymentOpt('COD'),
    _PaymentOpt('E-Wallet'),
    _PaymentOpt('Transfer Bank'),
    _PaymentOpt('Pay Later'),
  ];
  String payment = '';

  // ==== Shipping (vertical cards) ====
  final List<_ShipOpt> _ships = const [
    _ShipOpt('Hemat',   '± 5 hari', Duration(days: 5), Icons.savings_outlined),
    _ShipOpt('Regular', '± 4 hari', Duration(days: 4), Icons.local_shipping_outlined),
    _ShipOpt('Cargo',   '± 7 hari', Duration(days: 7), Icons.directions_boat_outlined),
    _ShipOpt('Instan',  '± 1 jam',  Duration(hours: 1), Icons.bolt),
  ];
  _ShipOpt _selectedShip = const _ShipOpt('Hemat', '± 5 hari', Duration(days: 5), Icons.savings_outlined);

  String formatMoney(num v, String code) =>
      NumberFormat.currency(symbol: '$code ', decimalDigits: 2).format(v);

  String formatEta(DateTime dt) =>
      DateFormat('EEE, dd MMM yyyy • HH:mm').format(dt);

  @override
  Widget build(BuildContext context) {
    final selected = cart.selectedItems; // ringkasan item terpilih tetap ada
    if (selected.isEmpty) {
      return Scaffold(
        backgroundColor: page,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Checkout'),
          backgroundColor: card,
          surfaceTintColor: card,
          elevation: 0.5,
          foregroundColor: Colors.black87,
        ),
        body: const Center(child: Text('Tidak ada item terpilih')),
      );
    }

    final fx = curr.factorFromUsdTo(curr.selected.value);
    final totalUsd = cart.selectedTotal;
    final totalFx  = totalUsd * fx;
    final eta      = DateTime.now().add(_selectedShip.eta);

    return Scaffold(
      backgroundColor: page,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Checkout'),
        backgroundColor: card,
        surfaceTintColor: card,
        elevation: 0.5,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
        children: [
          // ==== Ringkasan (tetap seperti tampilan awal) ====
          const _SectionTitle('Ringkasan'),
          Container(
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12.withOpacity(.06)),
            ),
            child: Column(
              children: [
                for (int i = 0; i < selected.length; i++) ...[
                  _SummaryTile(
                    title: selected[i].title,
                    thumb: selected[i].thumbnail,
                    qty: selected[i].qty,
                    secondary: 'x${selected[i].qty} • '
                        '${formatMoney(selected[i].price * fx, curr.selected.value)}',
                    trailing: formatMoney(selected[i].subTotal * fx, curr.selected.value),
                  ),
                  if (i != selected.length - 1)
                    Divider(height: 1, color: Colors.black12.withOpacity(.10)),
                ]
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ==== Pengiriman (diubah: 4 kartu vertikal memanjang) ====
          const _SectionTitle('Pengiriman'),
          _ShippingList(
            options: _ships,
            selected: _selectedShip,
            onPick: (opt) => setState(() => _selectedShip = opt),
          ),

          const SizedBox(height: 12),
          // Perkiraan sampai (tetap ada tampilan awal)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12.withOpacity(.08)),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule_outlined, size: 18),
                const SizedBox(width: 10),
                const Text('Perkiraan sampai', style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(formatEta(eta), style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const _SectionTitle('Metode Pembayaran'),
          _PaymentRadioGroup(
            options: _payments,
            value: payment,
            onChanged: (v) => setState(() => payment = v),
          ),

          const SizedBox(height: 20),

          // ==== Total (tetap) ====
          const _SectionTitle('Total'),
          Container(
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12.withOpacity(.06)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(curr.selected.value, style: const TextStyle(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text(
                  formatMoney(totalFx, curr.selected.value),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: rose,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ==== Tombol Bayar (tetap) ====
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: rose,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                try {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Konfirmasi Pembayaran'),
                      content: Text(
                        'Bayar ${formatMoney(totalFx, curr.selected.value)} sekarang?\n\n'
                        'Pengiriman: ${_selectedShip.name} (${_selectedShip.label})\n'
                        'Perkiraan sampai: ${formatEta(eta)}',
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: rose),
                          child: const Text('Bayar'),
                        ),
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
                    shipping: _selectedShip.name,
                  );

                  // 2) Hapus item terpilih
                  cart.removeSelected();

                  // 3) Notifikasi
                  await NotificationService.showSuccess(
                    'Pembayaran Berhasil',
                    'Total: ${formatMoney(totalFx, curr.selected.value)}\n'
                    'Pengiriman: ${_selectedShip.name} (${_selectedShip.label})\n'
                    'Perkiraan tiba: ${formatEta(eta)}',
                  );

                  // 4) Pindah ke Transaksi + kirim ETA (kalau mau dipakai di detail)
                  Get.offAll(() => const TransaksiView(), arguments: {
                    'eta': eta.toIso8601String(),
                    'shipOption': _selectedShip.name,
                  });
                } catch (e, st) {
                  debugPrint('[CHECKOUT][ERROR] $e\n$st');
                  Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM);
                }
              },
              child: const Text('Bayar Sekarang', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}

// ====== Widgets sederhana & yang diubah ======

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14.5,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.title,
    required this.thumb,
    required this.qty,
    required this.secondary,
    required this.trailing,
  });

  final String title;
  final String thumb;
  final int qty;
  final String secondary; // contoh: x2 • USD 10.00
  final String trailing;  // subtotal

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(thumb, width: 52, height: 52, fit: BoxFit.cover),
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(
        secondary,
        style: const TextStyle(color: Colors.black54),
      ),
      trailing: Text(
        trailing,
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

// === Shipping list: 4 kartu vertikal memanjang ===
class _ShippingList extends StatelessWidget {
  final List<_ShipOpt> options;
  final _ShipOpt selected;
  final ValueChanged<_ShipOpt> onPick;
  const _ShippingList({
    required this.options,
    required this.selected,
    required this.onPick,
  });

  static const rose = Color(0xFFE8A0BF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isSel = opt == selected;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSel ? rose : Colors.black12.withOpacity(.25),
              width: isSel ? 1.8 : 1,
            ),
          ),
          child: ListTile(
            onTap: () => onPick(opt),
            leading: Icon(opt.icon, color: isSel ? rose : Colors.black54),
            title: Text(
              opt.name,
              style: TextStyle(fontWeight: isSel ? FontWeight.w800 : FontWeight.w600),
            ),
            subtitle: Text(opt.label, style: const TextStyle(color: Colors.black54)),
            trailing: Radio<_ShipOpt>(
              value: opt,
              groupValue: selected,
              onChanged: (v) => onPick(v!),
              activeColor: rose,
            ),
          ),
        );
      }).toList(),
    );
  }
}

// === Payment radio: opsi bulat (radio button), bukan tombol bulat ===
class _PaymentRadioGroup extends StatelessWidget {
  final List<_PaymentOpt> options;
  final String value;
  final ValueChanged<String> onChanged;
  const _PaymentRadioGroup({
    required this.options,
    required this.value,
    required this.onChanged,
  });

  static const rose = Color(0xFFE8A0BF);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12.withOpacity(.2)),
          ),
          child: RadioListTile<String>(
            value: opt.label,
            groupValue: value,
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
            activeColor: rose,
            title: Text(opt.label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        );
      }).toList(),
    );
  }
}

// ==== Models kecil untuk opsi ====
class _ShipOpt {
  final String name;
  final String label;
  final Duration eta;
  final IconData icon;
  const _ShipOpt(this.name, this.label, this.eta, this.icon);

  @override
  bool operator ==(Object other) => other is _ShipOpt && name == other.name;
  @override
  int get hashCode => name.hashCode;
}

class _PaymentOpt {
  final String label;
  const _PaymentOpt(this.label);
}
