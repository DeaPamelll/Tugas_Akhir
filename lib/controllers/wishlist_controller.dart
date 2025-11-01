import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../services/auth_service.dart';

class WishlistController extends GetxController {
  final RxnInt _userId = RxnInt();
  Box<bool>? _box; // key: productId, value: true

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
      uid = null;
    }
    await setActiveUser(uid);
  }

  String _boxNameFor(int? userId) => 'wishlist_${userId?.toString() ?? 'guest'}';

  Future<void> setActiveUser(int? userId) async {
    if (_box?.isOpen == true) await _box!.close();
    _userId.value = userId;
    _box = await Hive.openBox<bool>(_boxNameFor(userId));
  }

  bool contains(int productId) => _box?.get(productId, defaultValue: false) ?? false;

  void toggle(int productId) {
    final cur = contains(productId);
    if (cur) {
      _box?.delete(productId);
    } else {
      _box?.put(productId, true);
    }
  }

  int get count => _box?.length ?? 0;
}
