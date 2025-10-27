import 'dart:io';
import 'package:hive/hive.dart';

part 'message.g.dart'; // Generated file

@HiveType(typeId: 0) // Unique typeId for Message
class Message {
  @HiveField(0)
  final String text;
  @HiveField(1)
  final bool isUser;
  @HiveField(2)
  final bool isLoading;
  @HiveField(3)
  final String? imagePath; // Store image path instead of File

  Message({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.imagePath,
  });

  // Helper to convert File to path for storage
  factory Message.fromFile({
    required String text,
    required bool isUser,
    bool isLoading = false,
    File? image,
  }) {
    return Message(
      text: text,
      isUser: isUser,
      isLoading: isLoading,
      imagePath: image?.path,
    );
  }

  // Helper to get File from path
  File? get imageFile => imagePath != null ? File(imagePath!) : null;
}
