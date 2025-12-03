// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int?,
      username: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      createdAt: fields[4] as DateTime,
      role: fields[5] as String?,
      photoPath: fields[6] as String?,
      hobbies: (fields[7] as List?)?.cast<String>(),
      instagram: fields[8] as String?,
      nim: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.role)
      ..writeByte(6)
      ..write(obj.photoPath)
      ..writeByte(7)
      ..write(obj.hobbies)
      ..writeByte(8)
      ..write(obj.instagram)
      ..writeByte(9)
      ..write(obj.nim);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
