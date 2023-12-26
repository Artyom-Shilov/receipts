import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:receipts/recipe_info/widgets/recipe_info_screen_body.dart';

class RecipeInfoScreen extends StatelessWidget {
  const RecipeInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              titleTextStyle: const TextStyle(
                  color: AppColors.main,
                  fontSize: 20,
                  fontWeight: FontWeight.w400),
              title: const Text(RecipeInfoTexts.appBarTitle),
              actions: [
                GestureDetector(
                  child: const Icon(
                    Icons.add_a_photo,
                    size: 20,
                  ),
                  onTap: () {
                    final recipeInfoCubit =
                    BlocProvider.of<BaseRecipeInfoCubit>(context);
                    GoRouter.of(context).go(
                      '/${AppTabs.recipes}'
                          '/${RecipesRouteNames.recipe}'
                          '/${recipeInfoCubit.recipe.id}'
                          '/${RecipesRouteNames.camera}',
                      extra: recipeInfoCubit.recipe,
                    );
                  },
                ),
              ],
            ),
            body: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
                //buildWhen: (prev, next) => prev.status != next.status,
              builder: (context, state) {
                print('Rebuild !!!! ${state.recipe.userPhotos.length}');
                return switch (state.status) {
                  RecipeInfoStatus.success =>
                    RecipeInfoScreenBody(recipe: state.recipe),
                  RecipeInfoStatus.error => Center(child: Text(state.message)),
                };
              },
            )));
  }
}
