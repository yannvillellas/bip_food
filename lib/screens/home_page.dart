import 'dart:io';
import 'package:bip_food/data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../util/food_tile.dart';
import '../util/dialog_box.dart';
import '../notification_manager/notification_manager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _myBox = Hive.box('myBox');
  final _controller = TextEditingController();
  FoodDatabase db = FoodDatabase();

  @override
  void initState() {
    super.initState();
    if (_myBox.get('FOODLIST') == null) {
      db.createInitialData();
      db.updateDatabase();
    } else {
      db.loadData();
      // db.createInitialData();
      // db.updateDatabase();
    }
    NotificationManager.initialize(flutterLocalNotificationsPlugin);
  }

  void _removeFood(int index) {
    db.updateDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Food removed'),
        duration: Duration(seconds: 1),
      ),
    );
    setState(() {
      db.foodList.removeAt(index);
    });
  }

  //save a new ingredient to the hive box
  void saveNewIngredient(DateTime date) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Food added'),
        duration: Duration(seconds: 1),
      ),
    );
    setState(() {
      if (File('assets/images/${_controller.text.toLowerCase()}.png')
          .existsSync()) {
        db.foodList.add([
          _controller.text,
          'assets/images/${_controller.text.toLowerCase()}.png',
          date,
        ]);
      } else {
        db.foodList.add([
          _controller.text,
          'assets/images/default.png',
          date,
        ]);
      }

      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void _addFood(BuildContext context) {
    DateTime selectedDate =
        DateTime.now(); // Initialize the selected date variable
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () =>
              saveNewIngredient(selectedDate), // Pass the selected date
          onCancel: () => Navigator.of(context).pop(),
          onDateSelected: (date) {
            selectedDate = date; // Update the selected date variable
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5D6),
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Bip Food', style: TextStyle(color: Colors.black)),
        elevation: 0,
        backgroundColor: const Color(0xFFFFF5D6),
        actions: [
          Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: IconButton(
                  icon: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/logo.png'),
                    radius:
                        20, // Half of the width and height for a circular shape
                  ),
                  onPressed: () {
                    // FIXME: to be removed - write "button pressed" on display dialog box to test if the button works
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bip Food'),
                          content: const Text('Version 0.0.4'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _addFood(context);
          // FIXME: to be removed
          NotificationManager.displayNotification(
              title: 'Bip Food',
              body: 'You have added a new food item',
              flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: ListView.builder(
        itemCount: db.foodList.length,
        itemBuilder: (context, index) {
          return FoodTile(
            foodName: db.foodList[index][0],
            foodImage: db.foodList[index][1],
            foodExpiryDate: db.foodList[index][2],
            removeIngredient: (context) => _removeFood(index),
          );
        },
      ),
    );
  }
}
