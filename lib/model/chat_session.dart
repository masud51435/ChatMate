import 'package:hive/hive.dart';
import '../common/message.dart';

part 'chat_session.g.dart'; // Generated file

@HiveType(typeId: 1) // Unique typeId for ChatSessions
class ChatSessions extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime createdAt;
  @HiveField(2)
  List<Message> messages;

  ChatSessions({
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}
