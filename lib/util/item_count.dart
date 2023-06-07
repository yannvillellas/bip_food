import 'package:bip_food/main.dart';
import 'package:flutter/material.dart';
import 'package:bip_food/data/database.dart';

class ItemCount extends StatefulWidget {
  final FoodDatabase db;
  final Color color;
  final Function(Color)? onColorSelected;
  const ItemCount({
    super.key,
    required this.db,
    required this.color,
    this.onColorSelected,
  });

  @override
  State<ItemCount> createState() => _ItemCountState();
}

class _ItemCountState extends State<ItemCount> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.onColorSelected != null) {
          // Add this check
          widget.onColorSelected!(
              widget.color); // Call the onColorSelected method
        }
      },
      child: Container(
          width: 60,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: purple,
                  spreadRadius: 0.5,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              Container(
                margin: const EdgeInsets.only(left: 8),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          )),
    );
  }
}
