import 'dart:io';

class Message {
  Message({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.image,
  });
  final String text;
  final bool isUser;
  final bool isLoading;
  final File? image;
}
