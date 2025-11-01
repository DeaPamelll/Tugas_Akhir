// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderAdapter extends TypeAdapter<Order> {
  @override
  final int typeId = 22;

  @override
  Order read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Order(
      orderId: fields[0] as String,
      userId: fields[1] as int?,
      items: (fields[2] as List).cast<OrderItem>(),
      totalUsd: fields[3] as double,
      shippingCostUsd: fields[4] as double,
      paymentMethod: fields[5] as String,
      courier: fields[6] as String,
      etaDays: fields[7] as int,
      createdAtUtc: fields[8] as DateTime,
      etaUtc: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Order obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.orderId)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.totalUsd)
      ..writeByte(4)
      ..write(obj.shippingCostUsd)
      ..writeByte(5)
      ..write(obj.paymentMethod)
      ..writeByte(6)
      ..write(obj.courier)
      ..writeByte(7)
      ..write(obj.etaDays)
      ..writeByte(8)
      ..write(obj.createdAtUtc)
      ..writeByte(9)
      ..write(obj.etaUtc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
