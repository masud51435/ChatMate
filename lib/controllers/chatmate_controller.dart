import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chatmate/api/api_key.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

  late Box<ChatSessions> _chatSessionsBox;

  @override
  void onInit() {
    super.onInit();
    _chatSessionsBox = Hive.box<ChatSessions>('chatSessionsBox');
    _loadChatSessions(); // Load sessions on controller initialization
  }

  void _loadChatSessions() {
    chatSessions.assignAll(_chatSessionsBox.values.toList());
    if (chatSessions.isNotEmpty) {}
  }

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

      // Show a more professional and user-friendly dialog for image description
      final description = await Get.defaultDialog<String>(
        title: "Describe the Image",
        contentPadding: const EdgeInsets.all(16.0),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selectedImage.value != null)
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: FileImage(selectedImage.value!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                ),
              TextFormField(
                controller: imageDescriptionController,
                maxLines: null, // Allow multiple lines for description
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Your Description',
                  hintText: 'What do you want to know about this image?',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        confirm: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Get.back(result: imageDescriptionController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor, // Use theme primary color
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Analyze Image'),
        ),
        cancel: TextButton(
          onPressed: () {
            Get.back();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          child: const Text('Cancel'),
        ),
      );

      if (description != null) {
        //add the image in the message list
        messages.add(
          Message.fromFile(
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
    try {
      final apiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$GEMINI_IMAGE_API_KEY";

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
        Get.snackbar(
          'Image Analysis Error',
          'Failed to analyze image. Status: ${response.statusCode}. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return 'Error: Failed to analyze image.'; // Return a generic error for message list
      }
    } catch (e) {
      Get.snackbar(
        'Image Analysis Error',
        'An unexpected error occurred during image analysis: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return 'Error: ${e.toString()}';
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
        model: 'gemini-2.5-flash',
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
      if (response.text == null || response.text!.isEmpty) {
        Get.snackbar(
          'Gemini AI Error',
          'Gemini AI did not return a valid response. Please try rephrasing your query.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        messages.add(
          Message(
            text: 'No response from AI. Please try again.',
            isUser: false,
          ),
        );
      } else {
        messages.add(
          Message(
            text: response.text!,
            isUser: false,
          ),
        );
      }
      _scrollDown();

      // Clear the description and vision responses after using them
      descriptions.value = '';
      visionResponses.value = '';

      // After adding messages, update the current session in Hive
      if (currentSessionIndex.value != -1 &&
          currentSessionIndex.value < chatSessions.length) {
        final currentSession = chatSessions[currentSessionIndex.value];
        currentSession.messages = List<Message>.from(messages);
        await currentSession.save(); // Save the HiveObject to persist changes
      }
    } catch (e) {
      isLoading.value = false;
      messages.removeLast(); // Remove loading message
      Get.snackbar(
        'Gemini AI Error',
        'An error occurred while communicating with Gemini AI: ${e.toString()}. Please check your internet connection and API key.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      messages.add(
        Message(
          text: 'Error: ${e.toString()}',
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
    // If there are messages in the current view, save them to a session
    if (messages.isNotEmpty) {
      if (currentSessionIndex.value != -1 && currentSessionIndex.value < chatSessions.length) {
        // Update existing session
        final currentSession = chatSessions[currentSessionIndex.value];
        currentSession.messages = List<Message>.from(messages);
        currentSession.save();
      } else {
        // Create a new session for the current messages
        final newSession = ChatSessions(
          title: "Chat ${chatSessions.length + 1}",
          messages: List<Message>.from(messages),
          createdAt: DateTime.now(),
        );
        chatSessions.add(newSession);
        _chatSessionsBox.add(newSession);
      }
    }
    // Now, clear the current view to start a truly new, empty chat
    messages.clear();
    isClear.value = true;
    currentSessionIndex.value = -1; // No active session for this new empty chat
  }

  //load a selected chat session
  void loadChatSession(int index) {
    final session = chatSessions[index];
    messages.assignAll(session.messages);
    currentSessionIndex.value = index;
    isClear.value = false;
  }

  //delete a chat session
  void deleteChatSession(int index) {
    if (index >= 0 && index < chatSessions.length) {
      final sessionToDelete = chatSessions[index];
      sessionToDelete.delete(); // Use HiveObject's delete method
      chatSessions.removeAt(index);
      // Handle currentSessionIndex if the deleted session was active
      if (currentSessionIndex.value == index) {
        currentSessionIndex.value = -1; // No active session
        messages.clear();
        isClear.value = true;
      } else if (currentSessionIndex.value > index) {
        currentSessionIndex.value--; // Adjust index if needed
      }
    }
  }
}
