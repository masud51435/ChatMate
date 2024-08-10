import 'package:flutter/material.dart';

import 'appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                children: [],
              ),
            ),
            Row(
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    size: 30,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
