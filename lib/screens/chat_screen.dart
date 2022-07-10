// ignore_for_file: deprecated_member_use, library_private_types_in_public_api, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? loggedInUser;
  String? messeageText;

  final _auth = FirebaseAuth.instance; //firebase_auth

  final fbStore = FirebaseFirestore.instance; //cloud_firestore

  CollectionReference message =
      FirebaseFirestore.instance.collection("message"); //collection message

  Future<void> addMessage() {
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

  //Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
  final Stream<QuerySnapshot> messageStream = FirebaseFirestore.instance
      .collection('message')
      .snapshots(); //collection message but return to stream

  void getMessageStream() async {
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
                // _auth.signOut();
                // Navigator.pop(context);
                // getMessage();
                getMessageStream();
              }),
        ],
        // title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: messageStream,
              builder: ((BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  List<Text> messageWidgets = [];
                  for (var message in messages) {
                    Map<String, dynamic> messageMap =
                        message.data() as Map<String, dynamic>;
                    final messageText = messageMap['text'];
                    final messageSender = messageMap['sender'];

                    final messageWidget =
                        Text('$messageText from $messageSender');

                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: messageWidgets,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
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
/*
 StreamBuilder<QuerySnapshot>(
                    stream: messageStream,
                    builder: ((BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        final messages = snapshot.data!.docs;
                        List<Text> messageWidgets = [];
                        for (var message in messages) {
                          Map<String, dynamic> messageMap =
                              message.data() as Map<String, dynamic>;
                          final messageText = messageMap['text'];
                          final messageSender = messageMap['sender'];

                          final messageWidget =
                              Text('$messageText from $messageSender');

                          messageWidgets.add(messageWidget);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: messageWidgets,
                        );
                      }
                      return const Center(
                        child: Text('Loading...'),
                      );
                    }),
                  ),



Expanded(
                    child: TextField(
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
*/