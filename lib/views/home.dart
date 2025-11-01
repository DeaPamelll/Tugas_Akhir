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
    // pastikan CartController ada (global)
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController(), permanent: true);
    }
  }

  final ProductController pc = Get.put(ProductController(ApiService()));
  final CartController cart = Get.find<CartController>();
  final _search = TextEditingController();

  static const ivory = Color(0xFFFFF8F0);
  static const blush = Color(0xFFFFDDE1);
  static const rose  = Color(0xFFE8A0BF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ivory,
      appBar: const HeaderWidget(),
      body: Obx(() {
        if (pc.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: pc.init,
          child: CustomScrollView(
            slivers: [

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                     TextField(
                      controller: _search,
                      onChanged: pc.onQueryChanged, // debounce ada di controller
                      decoration: InputDecoration(
                        hintText: 'Cari produk…',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: const Color(0xFFFFF8F9),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: Color(0xFFFFC0CB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: const BorderSide(color: rose, width: 2),
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

              // ================ Kategori Dinamis (horizontal) ================
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: Obx(() {
                    final cats = pc.categories;
                    if (cats.isEmpty) {
                      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
                    }

                    String catLabel(dynamic c) {
                      if (c is Map) return (c['name'] ?? c['slug'] ?? '').toString();
                      return c.toString();
                    }

                    String? catSlug(dynamic c) {
                      if (c == '__ALL__') return null; // sentinel "Semua"
                      if (c is Map) return (c['slug'] ?? c['name'] ?? '').toString().toLowerCase();
                      return c.toString().toLowerCase();
                    }

                    final list = ['__ALL__', ...cats];

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final raw   = list[i];
                        final label = raw == '__ALL__' ? 'Semua' : catLabel(raw);
                        final slug  = catSlug(raw);

                        final selected = (slug == null && pc.selectedCategory.value == null) ||
                                         (slug != null && pc.selectedCategory.value == slug);

                        return _CategoryCard(
                          label: titleCase(label),
                          icon: iconForCategory(label),
                          selected: selected,
                          onTap: () {
                            _search.clear();
                            pc.onQueryChanged('');
                            pc.pickCategory(slug); // slug boleh null untuk "Semua"
                          },
                        );
                      },
                    );
                  }),
                ),
              ),

              // ================= Grid Produk =================
              SliverPadding(
                padding: const EdgeInsets.all(8),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.66,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
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
                ),
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



class _CategoryCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFFFF0F5) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 120,
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: const Color(0xFFE8A0BF)),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
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
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Image.network(p.thumbnail, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              const SizedBox(height: 6),

              // ====== Rating Bintang ======
              Row(
                children: [
                  // bintang full
                  ...List.generate(
                    fullStars,
                    (_) => Icon(Icons.star, size: 14, color: Colors.amber.shade600),
                  ),
                  // setengah bintang (opsional)
                  if (hasHalf) Icon(Icons.star_half, size: 14, color: Colors.amber.shade600),
                  // bintang kosong
                  ...List.generate(
                    emptyStars,
                    (_) => Icon(Icons.star_border, size: 14, color: Colors.amber.shade600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                  ),
                ],
              ),

              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('USD ${p.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add_shopping_cart),
                  color: const Color(0xFFE8A0BF),
                  tooltip: 'Tambah ke keranjang',
                ),
              ]),
            ]),
          )
        ]),
      ),
    );
  }
}
