import 'package:flutter/material.dart';

import '../../common/message.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({
    super.key,
    required this.message,
   
  });

  final Message message;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 0,
        vertical: 2,
      ),
      leading: message.isUser
          ? const SizedBox.shrink()
          : Image.asset(
              'assets/images/gemini.png',
              height: 30,
            ),
      title: Align(
        alignment: message.isUser ? Alignment.topRight : Alignment.topLeft,
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
            color: message.isUser ? Colors.blue.shade400 : Colors.transparent,
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
  }
}
