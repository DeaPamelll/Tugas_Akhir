import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tugas_akhir/controllers/cart_controller.dart';
import 'package:tugas_akhir/views/widgets/footer_widget.dart';
import 'package:tugas_akhir/views/widgets/header_widget.dart';

import '../controllers/product_controller.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/utils_service.dart';
import 'detail.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key}) {
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
  }

  final ProductController pc = Get.put(ProductController(ApiService()));
  final CartController cart = Get.find<CartController>();
  final _search = TextEditingController();

  static const ivory = Color(0xFFFFF8F0);
  static const rose  = Color(0xFFE8A0BF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      appBar: const HeaderWidget(),
      body: Obx(() {
        // Loader hanya saat BOOT pertama
        if (pc.isBoot.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: pc.init,
          child: CustomScrollView(
            slivers: [
              // ============ Search ============
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0, -1),
                      end: Alignment(0, 1),
                      colors: [Color(0xFFFFF0F6), Color(0x00FFF0F6)],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _search,
                          onChanged: pc.onQueryChanged,
                          decoration: InputDecoration(
                            hintText: 'Cari produk…',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: const Color(0xFFFFF8F9),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: BorderSide(color: rose.withOpacity(.35)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(22)),
                              borderSide: BorderSide(color: rose, width: 2),
                            ),
                          ),
                        ),
                        if (pc.isSearching.value)
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: LinearProgressIndicator(minHeight: 2),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // ============ Kategori (chips) ============
                  SliverToBoxAdapter(
                  child: SizedBox(
                    height: 96,
                    child: Obx(() {
                      final cats = pc.categories;

                      // >>> PENTING: baca selectedCategory di sini supaya Obx subscribe <<<
                      final sel = pc.selectedCategory.value;

                      if (cats.isEmpty) {
                        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                      }

                      String catLabel(dynamic c) {
                        if (c is Map) return (c['name'] ?? c['slug'] ?? '').toString();
                        return c.toString();
                      }

                      String? catSlug(dynamic c) {
                        if (c == '_ALL_') return null; // sentinel "Semua"
                        if (c is Map) return (c['slug'] ?? c['name'] ?? '').toString().toLowerCase();
                        return c.toString().toLowerCase();
                      }

                      final list = ['_ALL_', ...cats];

                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (_, i) {
                          final raw   = list[i];
                          final label = raw == '_ALL_' ? 'Semua' : catLabel(raw);
                          final slug  = catSlug(raw);

                          // pakai 'sel' yang sudah dibaca di atas
                          final selected = (slug == null && sel == null) || (slug != null && sel == slug);

                          return SizedBox(
                            width: 110,
                            child: _CategoryChip(
                              label: titleCase(label),
                              icon: iconForCategory(label),
                              selected: selected,
                              onTap: () {
                                pc.pickCategory(slug);   // update kategori
                                _search.clear();         // kosongkan pencarian
                                pc.onQueryChanged('');   // biar hasil kembali ke kategori aktif
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),


              // ============ Grid Produk ============
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                sliver: Obx(() {
                  // Tampilkan grid selalu; saat ganti kategori, tampilkan overlay loader ringan
                  final grid = SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.66,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) {
                        final p = pc.visible[i];
                        return _ProductCard(
                          p: p,
                          onAdd: () {
                            cart.add(p, qty: 1);
                            Get.snackbar(
                              'Keranjang',
                              'Ditambahkan: ${p.title}',
                              snackPosition: SnackPosition.BOTTOM,
                              margin: const EdgeInsets.all(12),
                            );
                          },
                          onTap: () => Get.to(() => DetailView(p: p)),
                        );
                      },
                      childCount: pc.visible.length,
                    ),
                  );

                  // Bungkus dengan Stack via SliverToBoxAdapter agar bisa overlay loader
                  return SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        // Grid di dalam layout normal
                        CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          slivers: [grid],
                        ),

                        // Overlay tipis saat isCatLoading
                        if (pc.isCatLoading.value)
                          Positioned.fill(
                            child: Container(
                              color: Colors.white.withOpacity(0.35),
                              child: const Center(
                                child: SizedBox(
                                  width: 28, height: 28,
                                  child: CircularProgressIndicator(strokeWidth: 2.5),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),
            ],
          ),
        );
      }),
      bottomNavigationBar: const FooterWidget(currentIndex: 0),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const rose = Color(0xFFE8A0BF);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF0F6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? rose : rose.withOpacity(.28),
            width: selected ? 1.6 : 1.1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: rose.withOpacity(.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: rose),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.black.withOpacity(.85),
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product p;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _ProductCard({
    required this.p,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final double rating = (p.rating is num) ? (p.rating as num).toDouble() : 0.0;
    final int fullStars  = rating.floor().clamp(0, 5);
    final bool hasHalf   = (rating - fullStars) >= 0.5 && fullStars < 5;
    final int emptyStars = 5 - fullStars - (hasHalf ? 1 : 0);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE8A0BF).withOpacity(.20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16),
                ),
                child: Image.network(
                  p.thumbnail,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      ...List.generate(
                        fullStars,
                        (_) => Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                      ),
                      if (hasHalf) Icon(Icons.star_half, size: 14, color: Colors.amber.shade600),
                      ...List.generate(
                        emptyStars,
                        (_) => Icon(Icons.star_border, size: 14, color: Colors.amber.shade600),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE8A0BF).withOpacity(.35)),
                        ),
                        child: Text(
                          'USD ${p.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black.withOpacity(.8),
                            fontSize: 12.5,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: onAdd,
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8A0BF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE8A0BF).withOpacity(.28),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const SizedBox(
                            height: 36, width: 42,
                            child: Center(
                              child: Icon(Icons.add_shopping_cart, color: const Color(0xFFE8A0BF), size: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
