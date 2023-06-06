import 'package:bip_food/main.dart';
import 'package:flutter/material.dart';
import 'package:bip_food/data/database.dart';

class ItemCount extends StatefulWidget {
  // add a required database wich will be used to get the foodList
  final FoodDatabase db;
  final Color color;
  const ItemCount({
    super.key,
    required this.db,
    required this.color,
  });

  @override
  State<ItemCount> createState() => _ItemCountState();
}

class _ItemCountState extends State<ItemCount> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(12),
          ),
          // write a text and an icon
          child: Row(
            children: [
              // write the number of colored items corresponding to the color
              Text(
                widget.color == red
                    ? widget.db.foodList
                        .where((element) =>
                            element[2].difference(DateTime.now()).inDays < 0)
                        .length
                        .toString()
                    : widget.color == yellow
                        ? widget.db.foodList
                            .where((element) =>
                                element[2].difference(DateTime.now()).inDays <
                                    3 &&
                                element[2].difference(DateTime.now()).inDays >=
                                    0)
                            .length
                            .toString()
                        : widget.color == green
                            ? widget.db.foodList
                                .where((element) =>
                                    element[2]
                                        .difference(DateTime.now())
                                        .inDays >
                                    3)
                                .length
                                .toString()
                            : widget.db.foodList.length.toString(),
              ),
            ],
          )),
    );
  }
}
