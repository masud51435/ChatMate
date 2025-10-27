import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatmate/controllers/chatmate_controller.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller = Get.find(); // Use Get.find() here

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
                  Get.back(); // Close the drawer
                },
                leading: const Icon(Icons.add_comment_outlined), // Consistent icon
                title: const Text(
                  'New Chat',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Divider(), // Separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Previous Chats',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
              Obx(
                () {
                  return ListView.builder(
                    itemCount: controller.chatSessions.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final session = controller.chatSessions[index];
                      final isActive = controller.currentSessionIndex.value == index;
                      return ListTile(
                        title: Text(
                          session.title,
                          style: TextStyle(
                            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                            color: isActive ? Get.theme.primaryColor : Colors.black,
                          ),
                        ),
                        subtitle: Text(session.createdAt.toLocal().toString().split('.')[0]), // Nicer date format
                        leading: Icon(
                          isActive ? Icons.chat_bubble : Icons.chat_bubble_outline,
                          color: isActive ? Get.theme.primaryColor : Colors.grey,
                        ),
                        onTap: () {
                          controller.loadChatSession(index);
                          Get.back(); // Close the drawer
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Chat?'),
                                content: Text('Are you sure you want to delete "${session.title}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      controller.deleteChatSession(index);
                                      Get.back(); // Close dialog
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
