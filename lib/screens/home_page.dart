import 'dart:io';
import 'package:bip_food/data/database.dart';
import 'package:bip_food/main.dart';
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
      // db.loadData();
      db.createInitialData();
      db.updateDatabase();
    }
    NotificationManager.initialize(flutterLocalNotificationsPlugin);
  }

  void _removeFood(int index) {
    db.updateDatabase();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: red,
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
        backgroundColor: green,
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
    db.foodList.sort((a, b) => a[2].compareTo(b[2]));
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: false,
        title: const Text('Bip Food',
            style: TextStyle(
                color: black, fontSize: 50, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: white,
        actions: [
          Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: IconButton(
                  icon: Image.asset(
                    'assets/images/logo_circle.png',
                    fit: BoxFit.contain,
                  ),
                  onPressed: () {
                    // FIXME: to be removed - write "button pressed" on display dialog box to test if the button works
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Bip Food'),
                          content: const Text('Version 0.0.6'),
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
        backgroundColor: purple,
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
          color: white,
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
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
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: 100,
          //     decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Colors.transparent, purple],
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
