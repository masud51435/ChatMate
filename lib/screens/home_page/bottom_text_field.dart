import 'package:flutter/material.dart';

class BottomTextField extends StatelessWidget {
  const BottomTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            maxLines: null,
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
          onPressed: () {},
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