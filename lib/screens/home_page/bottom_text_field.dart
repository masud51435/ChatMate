import 'package:flutter/material.dart';

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    super.key,
    required this.textEditingController,
    required this.onPressed,
    required this.imagePick,
  });

  final TextEditingController textEditingController;
  final void Function() onPressed;
  final void Function() imagePick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: textEditingController,
            maxLines: null,
            onTapOutside: (event) =>
                FocusManager.instance.primaryFocus!.unfocus(),
            decoration: InputDecoration(
              hintText: 'Message ChatMate',
              suffixIcon: IconButton(
                onPressed: imagePick,
                icon: const Icon(
                  Icons.image_outlined,
                  size: 30,
                ),
              ),
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
          onPressed: onPressed,
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
