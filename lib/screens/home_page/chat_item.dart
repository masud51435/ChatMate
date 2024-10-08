import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../common/message.dart';
import 'copy_text.dart';

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
      title: Align(
        alignment: message.isUser ? Alignment.topRight : Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.isUser
                ? const SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/gemini.png',
                        height: 35,
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            Container(
              margin: message.isUser
                  ? const EdgeInsets.only(left: 60)
                  : EdgeInsets.zero,
              padding: message.image != null
                  ? EdgeInsets.zero
                  : const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: message.isUser
                    ? const Border()
                    : message.isLoading
                        ? const Border()
                        : Border.all(color: Colors.grey),
                color: message.isUser
                    ? Colors.blue.shade400
                    : message.isLoading
                        ? Colors.transparent
                        : Colors.transparent,
              ),
              child: message.image != null
                  ? Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            message.image!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            message.text,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    )
                  : message.isLoading
                      ? Center(
                          child: LoadingAnimationWidget.beat(
                            color: Colors.blue.shade200,
                            size: 40,
                          ),
                        )
                      : Column(
                          children: [
                            Text(
                              message.text,
                              style: TextStyle(
                                color: message.isUser
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            message.isUser
                                ? const SizedBox.shrink()
                                : CopyText(
                                    message: message,
                                  ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
