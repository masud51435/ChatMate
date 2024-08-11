import '../common/message.dart';

class ChatSessions {
  String title;
  DateTime createdAt;
  List<Message> messages;

  ChatSessions({
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}
