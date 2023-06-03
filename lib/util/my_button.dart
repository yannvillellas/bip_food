import 'package:bip_food/main.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF896BB3).withOpacity(0.1),
            spreadRadius: 0.5,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onPressed,
        color: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
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
