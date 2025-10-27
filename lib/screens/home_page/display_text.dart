import 'package:flutter/material.dart';

class DisplayText extends StatelessWidget {
  const DisplayText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/gemini.png',
            height: 60,
          ),
          const SizedBox(height: 30),
          Text(
            'Hi, ChatMate \nHow can I help you?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Start a new conversation or select an image to analyze.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the camera icon to upload an image for analysis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
