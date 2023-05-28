import 'package:flutter/material.dart';
import '../util/my_button.dart';

class DialogBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    Key? key,
    required this.controller,
    required this.onDateSelected,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  late DateTime date;

  @override
  void initState() {
    super.initState();
    date = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.green[200],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Name input
          TextField(
            controller: widget.controller,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Food Name',
              hintStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          // Expiry date input
          Row(
            children: [
              const Expanded(
                flex: 4,
                child: Text(
                  'Expiry Date:',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  '${date.day < 10 ? '0${date.day}' : date.day}/${date.month < 10 ? '0${date.month}' : date.month}/${date.year}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.black),
                  onPressed: () async {
                    DateTime? newDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                    // Save button pressed
                    if (newDate != null) {
                      setState(() {
                        date =
                            newDate; // Update the date variable with the selected date
                      });
                      widget.onDateSelected(
                          newDate); // Pass the selected date to the function
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 24,
          ),

          // Save and cancel buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MyButton(
                text: 'Save',
                onPressed: widget.onSave,
              ),
              const SizedBox(
                width: 10,
              ),
              MyButton(
                text: 'Cancel',
                onPressed: widget.onCancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
