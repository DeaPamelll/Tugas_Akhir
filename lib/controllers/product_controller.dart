// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService api;
  ProductController(this.api);

  // Data
  final categories = <String>[].obs;   // semua kategori dari API
  final all = <Product>[].obs;         // cache semua produk (untuk "Semua")
  final visible = <Product>[].obs;     // produk yang sedang ditampilkan

  // State
  final selectedCategory = RxnString(); // null = Semua
  final isBoot = true.obs;              // loading awal (pertama kali buka Home)
  final isCatLoading = false.obs;       // loading saat ganti kategori
  final isSearching = false.obs;        // loading saat pencarian

  // Search (debounce)
  final query = ''.obs;
  Worker? _debouncer;

  @override
  void onInit() {
    super.onInit();
    init();
    _debouncer = debounce(query, (_) => _runSearch(), time: const Duration(milliseconds: 400));
  }

  /// Muat kategori & produk awal
  Future<void> init() async {
    try {
      isBoot.value = true;

      categories.value = await api.fetchCategories();

      final list = await api.fetchProducts(limit: 100);
      list.shuffle();
      all.assignAll(list);
      visible.assignAll(list);

      selectedCategory.value = null; // default "Semua"
    } catch (_) {
      // optional: snackbar/log
    } finally {
      isBoot.value = false;
    }
  }

  /// Dipanggil dari onChanged di TextField
  void onQueryChanged(String v) {
    query.value = v;
    if (v.trim().isEmpty) {
      // Kembalikan list ke kategori yang sedang aktif TANPA mengubah highlight
      // (tidak tampilkan loader global)
      pickCategory(selectedCategory.value, silent: true);
    }
  }

  /// Jalankan pencarian
  Future<void> _runSearch() async {
    final q = query.value.trim();
    if (q.isEmpty) return; // biar tidak menimpa hasil kategori

    try {
      isSearching.value = true;
      final res = await api.searchProducts(q);
      visible.assignAll(res);
    } catch (_) {
      // optional: error handling
    } finally {
      isSearching.value = false;
    }
  }

  /// Pilih kategori; null = Semua
  /// silent=true → jangan tunjukkan spinner kategori (dipakai saat clear search).
  Future<void> pickCategory(String? cat, {bool silent = false}) async {
    selectedCategory.value = cat;

    // "Semua" → pakai cache all (tanpa request network)
    if (cat == null) {
      final copy = [...all]..shuffle();
      visible.assignAll(copy);
      if (!silent) isCatLoading.value = false;
      return;
    }

    try {
      if (!silent) isCatLoading.value = true;
      final list = await api.fetchByCategory(cat);
      visible.assignAll(list);
    } catch (_) {
      // optional: error handling
    } finally {
      if (!silent) isCatLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debouncer?.dispose();
    super.onClose();
  }
}
