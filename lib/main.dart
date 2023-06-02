import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../screens/home_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

const Color white = Color(0xFFFFF5D6);
const Color yellow = Color(0xFFFFE085);
const Color green = Color(0xFF4CAF50);
const Color red = Color(0xFFFF595E);
const Color blue = Color(0xFF38A3E5);
const Color purple = Color(0xFF896BB3);
const Color black = Color(0xFF000000);

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bip Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Montserrat',
          brightness: Brightness.light,
          primaryColor: const Color(0xFFFFF5D6),
          primarySwatch: buildMaterialColor(const Color(0xFFFFE085))),
      home: const MyHomePage(),
    );
  }
}
