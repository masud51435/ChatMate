import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/message.dart';

class CopyText extends StatelessWidget {
  const CopyText({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomRight,
        child: InkWell(
          onTap: () {
            Clipboard.setData(
              ClipboardData(
                text: message.text,
              ),
            ).then(
              (value) {
                Get.showSnackbar(
                  const GetSnackBar(
                    message:
                        'Text copied to clipboard!',
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.copy,
            color: Colors.grey.shade500,
          ),
        ),
      );
  }
}