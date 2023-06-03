import 'package:hive_flutter/hive_flutter.dart';

class FoodDatabase {
  List foodList = [];

  //reference our box
  final _myBox = Hive.box('myBox');

  //run this method if this is the first time ever the app is opened
  void createInitialData() {
    foodList = [
      ['Cheese', 'assets/images/cheese.png', DateTime(2023, 05, 29)],
      ['Egg', 'assets/images/egg.png', DateTime(2023, 06, 12)],
      ['Pizza', 'assets/images/pizza.png', DateTime(2023, 06, 15)],
      ['Milk', 'assets/images/milk.png', DateTime(2023, 06, 20)],
      ['Apple', 'assets/images/apple.png', DateTime(2023, 05, 30)],
      ['Banana', 'assets/images/banana.png', DateTime(2023, 07, 05)],
      ['Carrot', 'assets/images/carrot.png', DateTime(2023, 07, 10)],
      ['Tomato', 'assets/images/tomato.png', DateTime(2023, 08, 10)],
      ['Watermelon', 'assets/images/watermelon.png', DateTime(2023, 05, 28)],
      ['Can', 'assets/images/can.png', DateTime(2023, 06, 05)],
      ['Kiwi', 'assets/images/kiwi.png', DateTime(2023, 06, 04)],
      ['Peach', 'assets/images/peach.png', DateTime(2023, 06, 03)]
    ];
  }

  //load the data from database
  void loadData() {
    foodList = _myBox.get('FOODLIST');
  }

  //update the database
  void updateDatabase() {
    _myBox.put('FOODLIST', foodList);
  }
}
