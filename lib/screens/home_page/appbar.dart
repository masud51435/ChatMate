import 'package:chatmate/screens/new_chat/new_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chatmate_controller.dart';

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
      title: const Text(
        'ChatMate',
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            controller.startNewChat();
            Get.offAll(() => const NewChatPage());
          },
          icon: const Icon(
            Icons.open_in_new,
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
