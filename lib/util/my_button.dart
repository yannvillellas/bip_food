import 'package:bip_food/main.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: purple,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
