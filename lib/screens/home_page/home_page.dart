import 'package:chatmate/controllers/chatmate_controller.dart';
import 'package:chatmate/api/home_drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appbar.dart';
import 'bottom_text_field.dart';
import 'chat_item.dart';
import 'display_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller = Get.put(ChatmateController());
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: controller.isClear.value
                    ? const DisplayText()
                    : ListView.builder(
                        itemCount: controller.messages.length,
                        controller: controller.scrollController,
                        itemBuilder: (BuildContext context, int index) {
                          final message = controller.messages[index];
                          return ChatItem(
                            message: message,
                          );
                        },
                      ),
              ),
            ),
            BottomTextField(
              textEditingController: controller.textController,
              onPressed: () {
                if (controller.textController.text.isNotEmpty) {
                  controller.callGeminiAiModal();
                  controller.textController.clear();
                }
              },
              imagePick: () {
                controller.pickImage();

              },
            ),
          ],
        ),
      ),
    );
  }
}
