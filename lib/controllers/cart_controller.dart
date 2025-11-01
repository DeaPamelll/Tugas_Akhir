import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/auth_service.dart';

class CartController extends GetxController {
  final RxnInt _userId = RxnInt();
  Box<CartItem>? _box; // box aktif untuk user sekarang

  // ---------- Selection untuk checkout (UNIQUE) ----------
  final Set<int> _selectedIds = {}; // simpan ID product yg dipilih

  bool isSelected(int id) => _selectedIds.contains(id);

  void toggleSelect(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    update();
  }

  void selectAll(bool v) {
    if (v) {
      _selectedIds
        ..clear()
        ..addAll(_vals.map((e) => e.id));
    } else {
      _selectedIds.clear();
    }
    update();
  }

  List<CartItem> get selectedItems =>
      _vals.where((e) => _selectedIds.contains(e.id)).toList();

  int get selectedDistinctCount => selectedItems.length;

  int get selectedQty =>
      selectedItems.fold(0, (a, e) => a + e.qty);

  double get selectedTotal =>
      selectedItems.fold(0.0, (a, e) => a + e.subTotal);

  /// Dipanggil setelah bayar → hapus item terpilih dari BOX
  void removeSelected() {
    final box = _box;
    if (box == null) return;
    for (final id in _selectedIds) {
      box.delete(id);
    }
    _selectedIds.clear();
    update();
  }

  // ---------- Helper aman null ----------
  Iterable<CartItem> get _vals => _box?.values ?? <CartItem>[];

  // ---------- Computed / getters ----------
  int get distinctCount => _box?.length ?? 0;                    // item unik → badge
  int get totalQty      => _vals.fold(0,   (a, e) => a + e.qty); // total kuantitas
  double get total      => _vals.fold(0.0, (a, e) => a + e.subTotal);
  Iterable<CartItem> get items => _vals;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    int? uid;
    try {
      uid = await AuthService().currentUserId();
    } catch (_) {
      uid = null; // guest
    }
    await setActiveUser(uid);
  }

  String _boxNameFor(int? userId) => 'cart_${userId?.toString() ?? 'guest'}';

  /// panggil saat login/logout untuk pindah cart
  Future<void> setActiveUser(int? userId) async {
    if (_box?.isOpen == true) await _box!.close();
    _userId.value = userId;
    _box = await Hive.openBox<CartItem>(_boxNameFor(userId));
    update(); // trigger GetBuilder rebuild (Header badge, CartView, Footer)
  }

  // ---------- Actions ----------
  void add(Product p, {int qty = 1}) {
    final box = _box;
    if (box == null) return;

    final existing = box.get(p.id);
    if (existing == null) {
      box.put(
        p.id,
        CartItem(
          id: p.id,
          title: p.title,
          // pastikan ke double walau p.price bisa num/int
          price: (p.price is num)
              ? (p.price as num).toDouble()
              : double.tryParse('${p.price}') ?? 0.0,
          thumbnail: p.thumbnail,
          qty: qty,
        ),
      );
    } else {
      existing.qty += qty;
      box.put(p.id, existing);
    }
    update();
  }

  void increase(int productId) {
    final box = _box;
    if (box == null) return;
    final cur = box.get(productId);
    if (cur == null) return;
    cur.qty += 1;
    box.put(productId, cur);
    update();
  }

  void decrease(int productId) {
    final box = _box;
    if (box == null) return;
    final cur = box.get(productId);
    if (cur == null) return;
    if (cur.qty > 1) {
      cur.qty -= 1;
      box.put(productId, cur);
    } else {
      box.delete(productId);
      _selectedIds.remove(productId); // kalau dihapus, unselect juga
    }
    update();
  }

  void remove(int productId) {
    _box?.delete(productId);
    _selectedIds.remove(productId);
    update();
  }

  Future<void> clear() async {
    await _box?.clear();
    _selectedIds.clear();
    update();
  }
}
