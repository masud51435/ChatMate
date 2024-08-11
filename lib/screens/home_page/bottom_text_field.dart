import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chatmate_controller.dart';

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scroll controller = Get.put(scroll());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: controller.textController,
            maxLines: null,
            onTapOutside: (event)=> FocusManager.instance.primaryFocus!.unfocus(),
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
    );
  }
}
