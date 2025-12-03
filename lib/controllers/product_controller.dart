import 'package:get/get.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductController extends GetxController {
  final ApiService api;
  ProductController(this.api);

  final categories = <String>[].obs;   
  final all = <Product>[].obs;         
  final visible = <Product>[].obs;     
  final selectedCategory = RxnString(); 
  final isBoot = true.obs;              
  final isCatLoading = false.obs;      
  final isSearching = false.obs;        

  final query = ''.obs;
  Worker? _debouncer;

  @override
  void onInit() {
    super.onInit();
    init();
    _debouncer = debounce(query, (_) => _runSearch(), time: const Duration(milliseconds: 400));
  }

  Future<void> init() async {
    try {
      isBoot.value = true;

      categories.value = await api.fetchCategories();

      final list = await api.fetchProducts(limit: 100);
      list.shuffle();
      all.assignAll(list);
      visible.assignAll(list);

      selectedCategory.value = null; 
    } catch (_) {
    } finally {
      isBoot.value = false;
    }
  }

  void onQueryChanged(String v) {
    query.value = v;
    if (v.trim().isEmpty) {

      pickCategory(selectedCategory.value, silent: true);
    }
  }

 
  Future<void> _runSearch() async {
    final q = query.value.trim();
    if (q.isEmpty) return; 

    try {
      isSearching.value = true;
      final res = await api.searchProducts(q);
      visible.assignAll(res);
    } catch (_) {

    } finally {
      isSearching.value = false;
    }
  }


  Future<void> pickCategory(String? cat, {bool silent = false}) async {
    selectedCategory.value = cat;

   
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
