import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatmate/controllers/chatmate_controller.dart';

import '../new_chat/new_chat.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller = Get.put(ChatmateController());

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        children: [
          Column(
            children: [
              InkWell(
                onTap: () => Get.back(),
                child: Image.asset(
                  'assets/images/aichat.png',
                  height: 60,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'ChatMate',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(color: Colors.black),
              ListTile(
                onTap: () {
                  controller.startNewChat();
                  Get.back();
                  Get.offAll(() => const NewChatPage());
                },
                leading: Image.asset(
                  'assets/images/aichat.png',
                  height: 20,
                ),
                title: const Text(
                  'New Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Obx(
            () {
              return ListView.builder(
                itemCount: controller.chatSessions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final session = controller.chatSessions[index];
                  return ListTile(
                    title: Text(session.title),
                    subtitle: Text(session.createdAt.toString()),
                    onTap: () {
                      // Load the selected chat session
                      controller.loadChatSession(index);
                      Navigator.pop(context); // Close the drawer
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
