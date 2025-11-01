import 'package:hive/hive.dart';
import 'order_item.dart';

part 'order.g.dart'; // hapus bila pakai adapter manual

@HiveType(typeId: 22)
class Order extends HiveObject {
  @HiveField(0) String orderId;       // uuid / timestamp string
  @HiveField(1) int? userId;          // null = guest
  @HiveField(2) List<OrderItem> items;
  @HiveField(3) double totalUsd;      // total barang (USD)
  @HiveField(4) double shippingCostUsd;
  @HiveField(5) String paymentMethod; // "COD"/"Bank Transfer"/"E-Wallet"/"Credit Card"
  @HiveField(6) String courier;       // mis: "JNE Reg"
  @HiveField(7) int etaDays;          // estimasi hari
  @HiveField(8) DateTime createdAtUtc;
  @HiveField(9) DateTime etaUtc;

  Order({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.totalUsd,
    required this.shippingCostUsd,
    required this.paymentMethod,
    required this.courier,
    required this.etaDays,
    required this.createdAtUtc,
    required this.etaUtc,
  });

  double get grandTotalUsd => totalUsd + shippingCostUsd;
}
