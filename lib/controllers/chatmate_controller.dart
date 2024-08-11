import 'package:chatmate/api/api_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../common/message.dart';

class scroll extends GetxController {
  static scroll get instance => Get.find();

  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RxBool isClear = true.obs;
  RxBool isLoading = false.obs;
  final RxList<dynamic> messages = [].obs;

// added scroll for automatically scrolling
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      ),
    );
  }

//added gemini functionality
  callGeminiAiModal() async {
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

      // added gemini functionality
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
