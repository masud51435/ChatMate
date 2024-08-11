import 'package:chatmate/screens/new_chat/new_chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(
          Icons.dashboard_outlined,
          size: 30,
        ),
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
            // Navigate to a new instance of NewChatPage and remove HomePage from the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const NewChatPage()),
              (route) => false,
            );
          },
          icon: const Icon(
            Icons.open_in_new_outlined,
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
