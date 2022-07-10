// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/MessageCover.dart';
import 'package:flutter/material.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
      .collection('message')
      .snapshots(); //collection message but return to stream

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('401'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Text('Loading...'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;
          List<MessageCover> messageWidgets = [];
          for (var message in messages) {
            Map<String, dynamic> messageMap =
                message.data() as Map<String, dynamic>;
            final messageText = messageMap['text'];
            final messageSender = messageMap['sender'];

            final messageWidget = MessageCover(
              text: messageText.toString(),
              sender: messageSender.toString(),
            );

            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: messageWidgets,
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
