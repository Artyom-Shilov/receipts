import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/ingredient.dart';

class IngredientsCard extends StatelessWidget {
  const IngredientsCard({Key? key, required this.ingredients})
      : super(key: key);

  final List<Ingredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.longestSide * 0.35,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.greyFont, width: 3.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final ingredient in ingredients)
            Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                Expanded(
                    flex: 20,
                    child: Text(
                      '• ${ingredient.title}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 8,
                    child: Text(ingredient.quantity,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.greyFont)))
              ],
            )
        ],
      ),
    );
  }
}
