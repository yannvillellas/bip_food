import 'package:flutter/material.dart';
import '../util/my_button.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  const DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[200],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            style: const TextStyle(color: Colors.green),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Food Name',
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          //save and cancel buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                text: 'Save',
                onPressed: onSave,
              ),
              const SizedBox(
                width: 10,
              ),
              MyButton(
                text: 'Cancel',
                onPressed: onCancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
