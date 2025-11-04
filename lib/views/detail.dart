import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import 'cart_view.dart'; // arahkan ke halaman keranjang

class DetailView extends StatelessWidget {
  final Product p;
  DetailView({super.key, required this.p});

  final CartController cart = Get.find<CartController>();

  static const rose = Color(0xFFE8A0BF);
  static const lightBg = Color(0xFFFFF8F9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0.8,
        centerTitle: true,
        title: Text(
          p.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // Ikon keranjang + badge
          GetBuilder<CartController>(
            builder: (_) {
              final count = cart.distinctCount;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Buka Keranjang',
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => Get.to(() => CartView()),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: rose,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 6),
        ],
      ),

      body: ListView(
        children: [
          // --- Gambar produk ---
          Hero(
            tag: p.id ?? p.title,
            child: AspectRatio(
              aspectRatio: 1.1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Image.network(p.thumbnail, fit: BoxFit.cover),
              ),
            ),
          ),

          // --- Info Produk ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    _InfoTag(icon: Icons.category, label: p.category),
                    const SizedBox(width: 8),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    Text(
                      p.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                Text(
                  'USD ${p.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: rose,
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  p.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.black.withOpacity(.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- Tombol di bawah ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: rose,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                cart.add(p);
                Get.snackbar(
                  'Keranjang',
                  'Ditambahkan: ${p.title}',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(12),
                  backgroundColor: Colors.white,
                  colorText: Colors.black87,
                  icon: const Icon(Icons.shopping_bag_outlined, color: rose),
                );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded),
              label: const Text(
                'Tambah ke Keranjang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Tag kecil untuk kategori atau info tambahan
class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.black.withOpacity(.7),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
