import 'package:flutter/material.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/ingredient.dart';

class IngredientsCard extends StatelessWidget {
  const IngredientsCard({Key? key, required this.ingredients})
      : super(key: key);

  final List<Ingredient> ingredients;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: Insets.vertical1),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.greyFont, width: 3.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (final ingredient in ingredients)
            Padding(
              padding: const EdgeInsets.only(bottom: Insets.vertical1),
              child: Row(
                children: [
                  const Spacer(
                    flex: 1,
                  ),
                  Expanded(
                      flex: 20,
                      child: Text(
                        '• ${ingredient.title}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  Expanded(
                      flex: 8,
                      child: Text(ingredient.quantity,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greyFont)))
                ],
              ),
            )
        ],
      ),
    );
  }
}
