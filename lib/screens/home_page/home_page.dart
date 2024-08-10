import 'package:chatmate/controllers/chatmate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'appbar.dart';

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
            Expanded(
              child: ListView.builder(
                itemCount: controller.messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = controller.messages[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 2,
                    ),
                    title: Align(
                      alignment: message.isUser
                          ? Alignment.topRight
                          : Alignment.topLeft,
                      child: Container(
                        margin: message.isUser
                            ? const EdgeInsets.only(left: 60)
                            : EdgeInsets.zero,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: message.isUser
                              ? const Border()
                              : Border.all(color: Colors.grey),
                          color: message.isUser
                              ? Colors.blue.shade400
                              : Colors.transparent,
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: message.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    maxLines: null,
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
