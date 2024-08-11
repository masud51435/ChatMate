import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatmate/controllers/chatmate_controller.dart';
import '../home_page/appbar.dart';
import '../home_page/chat_item.dart';
import '../home_page/display_text.dart';

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller =
        Get.put(ChatmateController(), tag: UniqueKey().toString());

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
                          print(message.text.toString());
                          return ChatItem(
                            message: message,
                          );
                        },
                      ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.textController,
                    maxLines: null,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus!.unfocus(),
                    decoration: InputDecoration(
                      hintText: 'Message ChatMate',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                IconButton.outlined(
                  onPressed: () {
                    controller.callGeminiAiModal();
                     controller.textController.clear();
                  },
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
