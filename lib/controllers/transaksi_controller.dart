import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';
import '../models/cart_item.dart';
import '../services/auth_service.dart';

class TransaksiController extends GetxController {
  late Box<TransactionModel> _box;
  int? _userId; 

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<TransactionModel>('transactions');
    _userId = await AuthService().currentUserId();
    update();
  }

  Future<void> setActiveUser(int? uid) async {
    _userId = uid;
    update();
  }

  List<TransactionModel> get items {
    if (_userId == null) {
      return <TransactionModel>[];
    }
    return _box.values
        .where((t) => t.userId == _userId)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> recordPayment({
    required List<CartItem> items,
    required double total,
    required String currency,
    required String paymentMethod,
    required String shipping,
  }) async {
    final uid = _userId ?? await AuthService().currentUserId();

    final tx = TransactionModel(
      id: DateTime.now().millisecondsSinceEpoch, 
      userId: uid,
      items: items,
      total: total,
      currency: currency,
      paymentMethod: paymentMethod,
      shipping: shipping,
      status: 'paid',
      createdAt: DateTime.now().toUtc(),
    );

    await _box.add(tx);

    update();
  }
}
