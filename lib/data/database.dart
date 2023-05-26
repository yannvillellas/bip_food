import 'package:hive_flutter/hive_flutter.dart';

class FoodDatabase {
  List foodList = [];

  //reference our box
  final _myBox = Hive.box('myBox');

  //run this method if this is the first time ever the app is opened
  void createInitialData() {
    foodList = [
      ['Cheese', 'assets/images/cheese.png', DateTime(2023, 05, 29)],
      ['Eggs', 'assets/images/egg.png', DateTime(2023, 06, 12)],
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
