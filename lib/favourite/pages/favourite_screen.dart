import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/favourite/controllers/favourite_recipes_state.dart';
import 'package:receipts/favourite/widgets/favourite_recipe_sliver_list.dart';
import 'package:receipts/recipes_list/pages/recipes_list_page.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseFavouriteRecipesCubit, FavouriteRecipesState>(
        builder: (context, state) {
          return switch (state.status) {
            FavouriteRecipesStatus.inStock || FavouriteRecipesStatus.init =>
              RecipesListPage(sliverList: FavouriteRecipeSliverList(recipes: state.favouriteRecipes)),
            FavouriteRecipesStatus.noFavouriteRecipes => const Center(
                child: Text(
                  FavouriteTexts.noFavouriteRecipes,
                  style: TextStyle(color: AppColors.accent),
                ),
              )
          };
        });
  }
}
