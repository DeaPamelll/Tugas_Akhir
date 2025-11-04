import 'package:hive/hive.dart';

part 'order_item.g.dart'; 

@HiveType(typeId: 21)
class OrderItem extends HiveObject {
  @HiveField(0) int id;        
  @HiveField(1) String title;
  @HiveField(2) double price;    
  @HiveField(3) String thumbnail;
  @HiveField(4) int qty;

  OrderItem({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.qty,
  });

  double get subTotal => price * qty;
}
