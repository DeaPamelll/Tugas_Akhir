import 'package:hive/hive.dart';
import 'order_item.dart';

part 'order.g.dart'; 

@HiveType(typeId: 22)
class Order extends HiveObject {
  @HiveField(0) String orderId;       
  @HiveField(1) int? userId;         
  @HiveField(2) List<OrderItem> items;
  @HiveField(3) double totalUsd;      
  @HiveField(4) double shippingCostUsd;
  @HiveField(5) String paymentMethod; 
  @HiveField(6) String courier;      
  @HiveField(7) int etaDays;        
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
