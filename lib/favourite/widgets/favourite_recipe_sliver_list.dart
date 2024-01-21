import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/favourite/controllers/favourite_recipes_state.dart';
import 'package:receipts/recipes_list/widgets/recipe_card.dart';

class FavouriteRecipeSliverList extends StatelessWidget {
  const FavouriteRecipeSliverList({Key? key, required this.recipes}) : super(key: key);

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    print('1111111111111111');
    print(recipes.length);
    return SliverList.separated(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return BlocBuilder<BaseFavouriteRecipesCubit, FavouriteRecipesState>(
              buildWhen: (prev, next) =>
                  prev.favouriteRecipes[index] != next.favouriteRecipes[index],
              builder: (context, state) =>
                  RecipeCard(recipe: state.favouriteRecipes[index]));
        },
        separatorBuilder: (context, index) {
          return SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.03);
        });
  }
}
