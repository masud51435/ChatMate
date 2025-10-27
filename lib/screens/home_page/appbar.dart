import 'package:chatmate/controllers/chatmate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ChatmateController controller = Get.find();
    return AppBar(
      backgroundColor: Colors.blueGrey.shade100,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: Image.asset('assets/images/aichat.png'),
      ),
      centerTitle: true,
      title: Obx(() {
        if (controller.currentSessionIndex.value != -1 &&
            controller.chatSessions.isNotEmpty) {
          return Text(
            controller.chatSessions[controller.currentSessionIndex.value].title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          );
        }
        return const Text(
          'ChatMate',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        );
      }),
      actions: [
        IconButton(
          onPressed: () {
            controller.startNewChat();
            // No need to navigate to NewChatPage anymore
          },
          icon: const Icon(
            Icons.add_comment_outlined, // More intuitive icon for new chat
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
