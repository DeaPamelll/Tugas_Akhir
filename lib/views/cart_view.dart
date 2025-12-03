import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/cart_controller.dart';
import '../controllers/k_mata_uang_controller.dart';
import 'checkout_view.dart';

class CartView extends StatelessWidget {
  CartView({super.key});

  final cart = Get.find<CartController>();
  final curr = Get.find<KMataUangController>();

  static const rose = Color(0xFFE8A0BF);

  String formatMoney(num value, String code) {
    final f = NumberFormat.currency(symbol: '$code ', decimalDigits: 2);
    return f.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (curr.loading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      if (curr.error.value != null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Keranjang')),
          body: Center(child: Text('Gagal memuat kurs:\n${curr.error.value}')),
        );
      }

      final fx = curr.factorFromUsdTo(curr.selected.value);

      return Scaffold(
        backgroundColor: const Color(0xFFFFF8F9),
        appBar: AppBar(
          title: const Text('Keranjang'),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0.5,
          centerTitle: true,
        ),

        body: GetBuilder<CartController>(
          builder: (_) {
            final items = cart.items.toList();
            if (items.isEmpty) {
              return const Center(child: Text('Keranjang masih kosong'));
            }

            final allSelected = items.isNotEmpty &&
                items.every((it) => cart.isSelected(it.id));

            return Column(
              children: [
                // ===== Bar Pilih Semua =====
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: allSelected,
                        onChanged: (v) => cart.selectAll(v ?? false),
                      ),
                      const Text('Pilih semua'),
                      const Spacer(),
                      Text(
                        'Dipilih: ${cart.selectedDistinctCount} item',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 120),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final it = items[i];
                      final unitUsd = (it.price as num).toDouble();
                      final subUsd = unitUsd * it.qty;
                      final unitFx = unitUsd * fx;
                      final subFx = subUsd * fx;
                      final checked = cart.isSelected(it.id);

                      return Card(
                        elevation: 0.5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
    
                              Checkbox(
                                value: checked,
                                onChanged: (_) => cart.toggleSelect(it.id),
                              ),


                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  it.thumbnail,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      it.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    Row(
                                      children: [
                                        _QtyBtn(icon: Icons.remove, onTap: () => cart.decrease(it.id)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Text(
                                            '${it.qty}',
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        _QtyBtn(icon: Icons.add, onTap: () => cart.increase(it.id)),
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatMoney(unitFx, curr.selected.value),
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatMoney(subFx, curr.selected.value),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: rose,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            
                              IconButton(
                                onPressed: () => cart.remove(it.id),
                                icon: const Icon(Icons.delete_outline),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),

        bottomNavigationBar: GetBuilder<CartController>(
          builder: (_) {
            final totalUsdSel = cart.selectedTotal;
            final fx = curr.factorFromUsdTo(curr.selected.value);
            final totalFxSel = totalUsdSel * fx;

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: curr.selected.value,
                            items: ['USD', 'IDR', 'EUR', 'JPY']
                                .map((c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) curr.selected.value = v;
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          formatMoney(totalFxSel, curr.selected.value),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: rose,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 48,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rose,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: cart.selectedQty == 0
                            ? null
                            : () {
                                Get.to(() => const CheckoutView());
                              },
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Icon(icon, size: 18),
      ),
    );
  }
}
