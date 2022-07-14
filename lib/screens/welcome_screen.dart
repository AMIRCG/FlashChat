// ignore_for_file: library_private_types_in_public_api, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flash_chat/components/ButtonCustom.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      // upperBound: 100.0,
    );
// controller!.reverse(from: 1.0);
    controller!.forward();
    controller!.addListener(() {
      setState(() {});
      print(animation!.value);
    });
    animation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(controller!);
    // animation =
    //     CurvedAnimation(parent: controller!, curve: Curves.easeInOutQuart);

    animation!.addStatusListener((status) {
      print(status);
      // if (status == AnimationStatus.completed) {
      //   controller!.reverse(from: 10);
      // } else if (status == AnimationStatus.dismissed) {
      //   controller!.forward();
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          animation!.value, //Colors.red.withOpacity(controller!.value)
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    //controller.value
                    //animation!.value * 100,
                    height: 60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const Text(
                  // '${controller!.value.toInt()}%',
                  'Flash Chat',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            ButtonCustom(
              pressButton: () {
                Navigator.pushNamed(context, '/LoginScreen');
              },
              colorButton: Colors.lightBlue,
              textButton: 'Log In',
            ),
            ButtonCustom(
              pressButton: () {
                Navigator.pushNamed(context, '/RegistrationScreen');
              },
              colorButton: Colors.purpleAccent,
              textButton: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }
}
