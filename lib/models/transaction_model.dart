import 'package:hive/hive.dart';

import 'cart_item.dart';

@HiveType(typeId: 40)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? userId;
  
  @HiveField(2)                 // <— siapa pemilik transaksi
  final List<CartItem> items;

  @HiveField(3)
  final double total;

  @HiveField(4)
  final String currency;

  @HiveField(5)
  final String paymentMethod;

  @HiveField(6)
  final String shipping;

  @HiveField(7)
  final String status;
  
  @HiveField(8)             
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.currency,
    required this.paymentMethod,
    required this.shipping,
    this.status = 'paid',
    required this.createdAt,
  });
}

