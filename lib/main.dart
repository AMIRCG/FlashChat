// ignore_for_file: unused_import, avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //note FB
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  FlashChat({Key? key}) : super(key: key);

  final Future<FirebaseApp> fbApp = Firebase.initializeApp(); //note FB

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/WelcomeScreen': (context) => const WelcomeScreen(),
        '/LoginScreen': (context) => const LoginScreen(),
        '/RegistrationScreen': (context) => const RegistrationScreen(),
        '/ChatScreen': (context) => const ChatScreen(),
      },

      //note FB
      home: FutureBuilder(
        future: fbApp,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            print('we have an error : ${snapshot.error}');
            return const Center(
              child: Text('Error'),
            );
          } else if (snapshot.hasData) {
            return const WelcomeScreen();
          } else {
            return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
