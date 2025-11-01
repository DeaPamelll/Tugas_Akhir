import 'package:hive/hive.dart';

class CartItem {
  final int id;            // product id
  final String title;
  final double price;      // harga per item
  final String thumbnail;
  int qty;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    this.qty = 1,
  });

  double get subTotal => price * qty;
}

// Adapter manual (tanpa build_runner / .g.dart)
class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 11;

  @override
  CartItem read(BinaryReader reader) {
    final fields = reader.readByte();
    final map = <int, dynamic>{};
    for (var i = 0; i < fields; i++) {
      map[reader.readByte()] = reader.read();
    }
    return CartItem(
      id: map[0] as int,
      title: map[1] as String,
      price: (map[2] as num).toDouble(),
      thumbnail: map[3] as String,
      qty: map[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.thumbnail)
      ..writeByte(4)
      ..write(obj.qty);
  }
}
