import '../common/message.dart';

class ChatSession {
  String title;
  DateTime createdAt;
  List<Message> messages;

  ChatSession({
    required this.title,
    required this.createdAt,
    required this.messages,
  });
}
