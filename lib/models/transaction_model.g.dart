import 'package:hive/hive.dart';
import 'package:tugas_akhir/models/cart_item.dart';
import 'package:tugas_akhir/models/transaction_model.dart';

class TransactionModelAdapter extends TypeAdapter<TransactionModel> {
  @override
  final int typeId = 40;

  @override
  TransactionModel read(BinaryReader reader) {
    final n = reader.readByte();
    final f = <int, dynamic>{};
    for (var i = 0; i < n; i++) {
      f[reader.readByte()] = reader.read();
    }
    return TransactionModel(
      id: f[0] as int,
      userId: f[1] as int?,
      items: (f[2] as List).cast<CartItem>(),
      total: (f[3] as num).toDouble(),
      currency: f[4] as String,
      paymentMethod: f[5] as String,
      shipping: f[6] as String,
      status: f[7] as String,
      createdAt: f[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter w, TransactionModel o) {
    w
      ..writeByte(9)
      ..writeByte(0)..write(o.id)
      ..writeByte(1)..write(o.userId)
      ..writeByte(2)..write(o.items)
      ..writeByte(3)..write(o.total)
      ..writeByte(4)..write(o.currency)
      ..writeByte(5)..write(o.paymentMethod)
      ..writeByte(6)..write(o.shipping)
      ..writeByte(7)..write(o.status)
      ..writeByte(8)..write(o.createdAt);
  }
}
