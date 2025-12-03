import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/transaction_model.dart';

class AdminTransaksiController extends GetxController {
  late Box<TransactionModel> _box;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    _box = await Hive.openBox<TransactionModel>('transactions');
    update();
  }

  List<TransactionModel> get allTransactions {
    return _box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double get totalIncome {
    return _box.values.fold(0.0, (sum, tx) => sum + tx.total);
  }

  Map<String, double> get monthlyIncome {
    final Map<String, double> data = {};

    for (var tx in _box.values) {
      final key = "${tx.createdAt.year}-${tx.createdAt.month}";
      data[key] = (data[key] ?? 0) + tx.total;
    }

    return data;
  }


  Future<void> updateStatus(int id, String status) async {
    final tx = _box.values.firstWhere((e) => e.id == id);

    final updated = TransactionModel(
      id: tx.id,
      userId: tx.userId,
      items: tx.items,
      total: tx.total,
      currency: tx.currency,
      paymentMethod: tx.paymentMethod,
      shipping: tx.shipping,
      status: status,
      createdAt: tx.createdAt,
    );

    await tx.delete();
    await _box.add(updated);

    update();
  }
}
