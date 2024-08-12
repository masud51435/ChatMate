import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:chatmate/api/api_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

import '../common/message.dart';
import '../model/chat_session.dart';

class ChatmateController extends GetxController {
  static ChatmateController get instance => Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();
  final TextEditingController imageDescriptionController =
      TextEditingController();
  final ScrollController scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  RxBool isClear = true.obs;
  RxBool isLoading = false.obs;
  final RxList<dynamic> messages = [].obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString descriptions = ''.obs;
  RxString visionResponses = ''.obs;
  RxString contentText = ''.obs;

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
    );
    if (image != null) {
      selectedImage.value = File(image.path);
      isClear.value = false;
      //get user description for the image
      final description = await Get.dialog(
        Form(
          key: _formKey,
          child: AlertDialog(
            title: const Text('Describe the image'),
            content: TextFormField(
              controller: imageDescriptionController,
              decoration: InputDecoration(
                hintText: 'What you want to know',
                filled: true,
                fillColor: Colors.grey.shade300,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your description';
                }
                return null;
              },
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('Cancel'),
              ),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Get.back(
                      result: imageDescriptionController.text,
                    );
                  }
                  return;
                },
                child: const Text('Ok'),
              ),
            ],
          ),
        ),
      );

      if (description != null) {
        //add the image in the message list
        messages.add(
          Message(
            image: selectedImage.value,
            text: description,
            isUser: true,
          ),
        );
        _scrollDown();

        //analyze the image using google vision API
        final visionResponse =
            await analyzeImageUsingVisionAPI(selectedImage.value!);

        //set the value
        visionResponses.value = visionResponse;
        descriptions.value = description;

        //call the Gemini AI for response
        await callGeminiAiModal();
      }
    }
  }

  Future<String> analyzeImageUsingVisionAPI(File image) async {
    const String apiUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$GEMINI_IMAGE_API_KEY";

    //convert the image to base64
    List<int> imageBytes = File(image.path).readAsBytesSync();
    final base64String = base64Encode(imageBytes);

    //create the request payload
    final Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": imageDescriptionController.text},
            {
              "inlineData": {
                "mimeType": "image/jpeg",
                "data": base64String,
              }
            }
          ]
        }
      ]
    };

    //send the request to the google Vision API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestBody),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final labels =
          jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
      return labels;
    } else {
      return 'Failed to analyze image';
    }
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
        // Reset contentText to handle only text input
        contentText.value = textController.text.trim();
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

      //combine user text and image description
      if (descriptions.isNotEmpty && visionResponses.isNotEmpty) {
        contentText.value = '${descriptions.value}, ${visionResponses.value}';
      }

      // added gemini AI responses
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: GEMINI_API_KEY,
      );
      final content = [
        Content.text(contentText.value),
      ];
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

      // Clear the description and vision responses after using them
      descriptions.value = '';
      visionResponses.value = '';
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

  /// Does not complete yet working on this section ///
  //store chat session
  final RxList<ChatSessions> chatSessions = <ChatSessions>[].obs;

  //current session index
  RxInt currentSessionIndex = (-1).obs;
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
}
