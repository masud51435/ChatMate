import 'dart:io';

import 'package:chatmate/api/api_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../common/message.dart';
import '../model/chat_session.dart';

class ChatmateController extends GetxController {
  static ChatmateController get instance => Get.find();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  RxBool isClear = true.obs;
  RxBool isLoading = false.obs;
  final RxList<dynamic> messages = [].obs;
  Rx<File?> selectedImage = Rx<File?>(null);

  //store chat session
  final RxList<ChatSessions> chatSessions = <ChatSessions>[].obs;

  //current session index
  RxInt currentSessionIndex = (-1).obs;

// added scroll for automatically scrolling
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  //image picker
  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 200,
      maxWidth: 200,
    );
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  //start a new chat session
  void startNewChat() {
    if (messages.isNotEmpty) {
      //save the current session before starting a new one
      chatSessions.add(ChatSessions(
        title: "Chat ${chatSessions.length + 1}",
        messages: List<Message>.from(messages),
        createdAt: DateTime.now(),
      ));
    }
    // CLear current message and start fresh
    messages.clear();
    isClear.value = true;
    currentSessionIndex.value = chatSessions.length;
  }

  //load a selected chat session
  void loadChatSession(int index) {
    final session = chatSessions[index];
    messages.assignAll(session.messages);
    currentSessionIndex.value = index;
    isClear.value = false;
  }

//added gemini functionality with loading indicator
  Future<void> callGeminiAiModal() async {
    try {
      //added user questions
      if (textController.text.isNotEmpty) {
        isClear.value = false;
        messages.add(Message(
          text: textController.text.trim(),
          isUser: true,
        ));
        _scrollDown();
      }

      //show loader
      isLoading.value = true;
      messages.add(
        Message(
          text: 'loading...',
          isUser: false,
          isLoading: true,
        ),
      );
      _scrollDown();

      // added gemini AI responses
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: GEMINI_API_KEY,
      );
      final content = [Content.text(textController.text.trim())];
      final response = await model.generateContent(content);

      //remove loader
      isLoading.value = false;
      messages.removeLast();

      //add gemini response to messages list
      messages.add(
        Message(
          text: response.text!,
          isUser: false,
        ),
      );
      _scrollDown();
    } catch (e) {
      isLoading.value = false;
      messages.removeLast();
      messages.add(
        Message(
          text: e.toString(),
          isUser: false,
        ),
      );
    }
  }
}
