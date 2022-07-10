// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MessageCover extends StatelessWidget {
  const MessageCover({Key? key, this.sender, this.text}) : super(key: key);
  final String? text;
  final String? sender;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            sender!,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 10,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(10),
            color: Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                text!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
