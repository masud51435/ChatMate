import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatmate/controllers/chatmate_controller.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller = Get.put(ChatmateController());

    return Drawer(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: controller.chatSessions.length,
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
    );
  }
}
