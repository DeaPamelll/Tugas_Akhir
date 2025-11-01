// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService api;
  ProductController(this.api);

  // State
  final categories = <String>[].obs;   // semua kategori dari API
  final all = <Product>[].obs;         // cache semua produk (untuk "Semua")
  final visible = <Product>[].obs;     // produk yang sedang ditampilkan

  final selectedCategory = RxnString(); // null = Semua
  final isLoading = false.obs;          // loading awal / ganti kategori
  final isSearching = false.obs;        // loading khusus search

  // Search dengan debounce
  final query = ''.obs;
  Worker? _debouncer;

  @override
  void onInit() {
    super.onInit();
    init();
    _debouncer =
        debounce(query, (_) => _runSearch(), time: const Duration(milliseconds: 400));
  }

  /// Muat kategori & produk awal
  Future<void> init() async {
    try {
      isLoading.value = true;
      categories.value = await api.fetchCategories();

      final list = await api.fetchProducts(limit: 100);
      list.shuffle();
      all.assignAll(list);
      visible.assignAll(list);

      selectedCategory.value = null; // default "Semua"
    } catch (e) {
      // kamu bisa tambahkan Snackbar/log di sini
    } finally {
      isLoading.value = false;
    }
  }

  /// Dipanggil dari onChanged di TextField
  void onQueryChanged(String v) {
    query.value = v;
  }

  /// Jalankan pencarian (dengan isSearching, tidak mengosongkan grid)
  Future<void> _runSearch() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      // kembalikan ke filter kategori terakhir
      await pickCategory(selectedCategory.value);
      return;
    }
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
  Future<void> pickCategory(String? cat) async {
    selectedCategory.value = cat;

    // Kalau "Semua" → pakai cache all
    if (cat == null) {
      final copy = [...all]..shuffle();
      visible.assignAll(copy);
      return;
    }

    try {
      isLoading.value = true;
      final list = await api.fetchByCategory(cat);
      visible.assignAll(list);
    } catch (_) {
      // optional: error handling
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debouncer?.dispose();
    super.onClose();
  }
}
