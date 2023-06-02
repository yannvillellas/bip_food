import 'package:bip_food/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FoodTile extends StatelessWidget {
  final String foodName;
  final String foodImage;
  final DateTime foodExpiryDate;
  final Function(BuildContext)? removeIngredient;
  const FoodTile({
    super.key,
    required this.foodName,
    required this.foodImage,
    required this.foodExpiryDate,
    this.removeIngredient,
  });

  Color _getCircleColor() {
    final DateTime currentDate = DateTime.now();
    final int difference = foodExpiryDate.difference(currentDate).inDays;

    if (difference < 0) {
      return red;
    } else if (difference < 3) {
      return yellow;
    } else {
      return green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: removeIngredient,
              icon: Icons.delete,
              backgroundColor: red,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
            padding: const EdgeInsets.all(15),
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
              children: [
                Image.asset(
                  foodImage,
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 15),
                Text(
                  foodName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Text(
                  '${foodExpiryDate.day < 10 ? '0${foodExpiryDate.day}' : foodExpiryDate.day}/${foodExpiryDate.month < 10 ? '0${foodExpiryDate.month}' : foodExpiryDate.month}/${foodExpiryDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getCircleColor(),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
