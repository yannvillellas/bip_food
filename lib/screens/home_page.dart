import 'package:bip_food/data/database.dart';
import 'package:bip_food/main.dart';
import 'package:bip_food/util/item_count.dart';
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
    setState(() {
      db.foodList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: red,
        content: Text('Food removed'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  // save a new ingredient to the hive box
  // brute force method to check for food image because checking for existence of image in assets folder does not work on android but just works on windows debug
  void saveNewIngredient(DateTime date) {
    setState(() {
      if (_controller.text.toLowerCase().contains('cheese')) {
        db.foodList.add([
          _controller.text,
          'assets/images/cheese.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('egg')) {
        db.foodList.add([
          _controller.text,
          'assets/images/egg.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('pizza')) {
        db.foodList.add([
          _controller.text,
          'assets/images/pizza.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('milk')) {
        db.foodList.add([
          _controller.text,
          'assets/images/milk.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('apple')) {
        db.foodList.add([
          _controller.text,
          'assets/images/apple.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('banana')) {
        db.foodList.add([
          _controller.text,
          'assets/images/banana.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('carrot')) {
        db.foodList.add([
          _controller.text,
          'assets/images/carrot.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('tomato')) {
        db.foodList.add([
          _controller.text,
          'assets/images/tomato.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('watermelon')) {
        db.foodList.add([
          _controller.text,
          'assets/images/watermelon.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('can')) {
        db.foodList.add([
          _controller.text,
          'assets/images/can.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('kiwi')) {
        db.foodList.add([
          _controller.text,
          'assets/images/kiwi.png',
          date,
        ]);
      } else if (_controller.text.toLowerCase().contains('peach')) {
        db.foodList.add([
          _controller.text,
          'assets/images/peach.png',
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

    NotificationManager.displayNotification(
        title: 'Bip Food',
        body:
            'You have added ${db.foodList.last[0]} which will expire on ${db.foodList.last[2].day}/${db.foodList.last[2].month}/${db.foodList.last[2].year}',
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);

    // create a notification 3 days before the expiry date of the food item received at 8am
    NotificationManager.scheduleExpiryReminderNotification(
        title: 'Bip Food',
        body:
            'Your ${db.foodList.last[0]} will expire in 3 days on ${db.foodList.last[2].day}/${db.foodList.last[2].month}/${db.foodList.last[2].year}. The notification will arrive at ${date.add(const Duration(days: 3)).add(const Duration(hours: 10)).add(const Duration(minutes: 0))}',
        notificationDate: date
            .subtract(const Duration(days: 3))
            .add(
              const Duration(hours: 10),
            )
            .add(
              const Duration(minutes: 00),
            ),
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);

    // // notification when the food item has expired
    NotificationManager.scheduleExpiryReminderNotification(
        title: 'Bip Food',
        body:
            'Your ${db.foodList.last[0]} has expired on ${db.foodList.last[2].day}/${db.foodList.last[2].month}/${db.foodList.last[2].year}. The notification will arrive at ${date.add(const Duration(hours: 0)).add(const Duration(seconds: 10))}',
        notificationDate: date
            .add(
              const Duration(hours: 0),
            )
            .add(
              const Duration(seconds: 10),
            ),
        flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: green,
        content: Text('Food added'),
        duration: Duration(seconds: 1),
      ),
    );
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
        toolbarHeight: 120,
        centerTitle: false,
        elevation: 0,
        backgroundColor: white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                const Text('Bip Food',
                    style: TextStyle(
                        color: black,
                        fontSize: 50,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/logo_circle.png',
                      fit: BoxFit.contain,
                    ),
                    onPressed: () {
                      // FIXME: to be removed - a profile page will be added
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Bip Food'),
                            content: const Text('Version 0.0.9'),
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
            // write a custom text to show the number of food items in the list, the number of red items and the number of green items
            Row(
              children: [
                ItemCount(db: db, color: purple),
                const SizedBox(width: 20),
                ItemCount(db: db, color: red),
                const SizedBox(width: 20),
                ItemCount(db: db, color: yellow),
                const SizedBox(width: 20),
                ItemCount(db: db, color: green),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: purple,
        onPressed: () {
          _addFood(context);
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
        ],
      ),
    );
  }
}
