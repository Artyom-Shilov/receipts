import 'package:flutter/material.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipes_list/widgets/recipe_card.dart';

class RecipeSliverList extends StatelessWidget {
  const RecipeSliverList({Key? key, required this.recipes}) : super(key: key);

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(
            recipe: recipes[index],
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.03);
        });
  }
}