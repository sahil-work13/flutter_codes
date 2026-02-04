// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todoModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TodomodelAdapter extends TypeAdapter<Todomodel> {
  @override
  final int typeId = 1;

  @override
  Todomodel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Todomodel(
      task: fields[0] as String?,
      description: fields[1] as String?,
      date: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Todomodel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.task)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TodomodelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
