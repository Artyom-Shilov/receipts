import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';
import 'package:receipts/recipes_list/pages/recipes_error_page.dart';
import 'package:receipts/recipes_list/pages/recipes_list_page.dart';
import 'package:receipts/recipes_list/widgets/recipe_sliver_list.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseRecipeListCubit, RecipeListState>(
      buildWhen: (prev, next) => prev.status != next.status,
      builder: (context, state) {
        return switch (state.status) {
          RecipeListStatus.initial ||
          RecipeListStatus.inProgress =>
            const Center(child: CircularProgressIndicator()),
          RecipeListStatus.error => const RecipesErrorPage(),
          RecipeListStatus.success => RecipesListPage(sliverList: RecipeSliverList(recipes: state.recipes))
        };
      },
    );
  }
}
