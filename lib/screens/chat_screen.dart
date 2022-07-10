// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print, unused_local_variable

import 'package:flash_chat/components/messageStream.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _auth = FirebaseAuth.instance; //firebase_auth

final fbStore = FirebaseFirestore.instance; //cloud_firestore

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextEditing = TextEditingController();
  User? loggedInUser;
  String? messeageText;

  CollectionReference message =
      FirebaseFirestore.instance.collection("message"); //collection message

  Future<void> addMessage() {
    messageTextEditing.clear();
    return message
        .add(
          {
            'text': messeageText,
            'sender': loggedInUser!.email.toString(),
          },
        )
        .then((value) => print('add Messages'))
        .catchError((onError) => print("Failed to add user: $onError"));
  } //Writing Data

  void getCurrentUser() async {
    final user = _auth.currentUser; //await

    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getMessage() async {
    final messages = await message.get(); //collection message
    for (var messageData in messages.docs) {
      print(messageData.data());
    }
  } //Read Data one time read

  void getMessageStream() async {
    final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
        .collection('message')
        .snapshots(); //collection message but return to stream
    await for (var snapShot in messageStream) {
      for (var message in snapShot.docs) {
        print(message.data.call()); //return map
      }
    }
  } //Realtime Changes

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                // getMessage();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextEditing,
                      onChanged: (value) {
                        messeageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: addMessage,
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
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
