import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatmateController extends GetxController {
  static ChatmateController get instance => Get.find();

  final TextEditingController controller = TextEditingController();

  final List<Message> messages = [
    Message(text: 'Hello, how are you?', isUser: true),
    Message(text: 'I\'m doing well, thank you!', isUser: false),
    Message(text: 'How about you?', isUser: true),
    Message(text: 'I\'m also doing well. What about you?', isUser: false),
    Message(text: 'What is your name?', isUser: true),
    Message(text: 'My name is gemini Ai, what is your name?', isUser: false),
    // Add more messages as needed...
  ];
}

class Message {
  Message({
    required this.text,
    required this.isUser,
  });
  final String text;
  final bool isUser;
}
