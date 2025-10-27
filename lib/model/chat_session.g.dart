// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatSessionsAdapter extends TypeAdapter<ChatSessions> {
  @override
  final int typeId = 1;

  @override
  ChatSessions read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatSessions(
      title: fields[0] as String,
      createdAt: fields[1] as DateTime,
      messages: (fields[2] as List).cast<Message>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChatSessions obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.messages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatSessionsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
