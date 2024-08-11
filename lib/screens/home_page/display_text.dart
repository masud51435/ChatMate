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
            'Hi, Masud \nHow can i help you,',
            style: TextStyle(
              fontSize: 30,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
