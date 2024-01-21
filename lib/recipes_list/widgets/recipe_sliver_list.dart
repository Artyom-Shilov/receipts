import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';
import 'package:receipts/recipes_list/widgets/recipe_card.dart';

class RecipeSliverList extends StatelessWidget {
  const RecipeSliverList({Key? key, required this.recipes}) : super(key: key);

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return BlocBuilder<BaseRecipeListCubit, RecipeListState>(
              buildWhen: (prev, next) =>
              prev.recipes[index] != next.recipes[index],
              builder: (context, state) => RecipeCard(recipe: state.recipes[index]));
          },
        separatorBuilder: (context, index) {
          return SizedBox(
              height: MediaQuery.of(context).size.longestSide * 0.03);
        });
  }
}