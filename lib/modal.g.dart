// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopicListAdapter extends TypeAdapter<TopicList> {
  @override
  final int typeId = 0;

  @override
  TopicList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopicList()
      ..name = fields[0] as String
      ..msgType = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, TopicList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.msgType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopicListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
