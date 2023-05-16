import 'dart:io';
import 'package:bip_food/data/database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../util/food_tile.dart';
import '../util/dialog_box.dart';

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
    }
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
  void saveNewIngredient() {
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
          'assets/images/${_controller.text.toLowerCase()}.png'
        ]);
      } else {
        db.foodList.add([_controller.text, 'assets/images/default.png']);
      }

      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  void _addFood(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _controller,
            onSave: saveNewIngredient,
            onCancel: () => Navigator.of(context).pop(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[200],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bip Food'),
        elevation: 0,
      ),
      // body: ListView(
      //   children: const [
      //     FoodTile(
      //       foodName: 'Cheese',
      //       foodImage: 'assets/images/cheese.png',
      //     ),
      //     FoodTile(
      //       foodName: 'Eggs',
      //       foodImage: 'assets/images/egg.png',
      //     ),
      //     FoodTile(
      //       foodName: 'Carrots',
      //       foodImage: 'assets/images/carrot.png',
      //     ),
      //   ],
      // ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _addFood(context);
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
            removeIngredient: (context) => _removeFood(index),
          );
        },
      ),
    );
  }
}
