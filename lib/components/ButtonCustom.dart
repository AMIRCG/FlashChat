// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ButtonCustom extends StatelessWidget {
  final Color? colorButton;
  final String? textButton;
  final VoidCallback pressButton;
  const ButtonCustom({
    required this.pressButton,
    this.colorButton,
    this.textButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorButton!,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          //      Navigator.pushNamed(context, '/LoginScreen');
          onPressed: pressButton,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            textButton!,
          ),
        ),
      ),
    );
  }
}
