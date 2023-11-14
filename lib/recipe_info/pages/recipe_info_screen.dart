import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/widgets/screen_body_recipe_found.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';

class RecipeInfoScreen extends StatefulWidget {
  const RecipeInfoScreen({Key? key, required this.recipeId}) : super(key: key);

  final String recipeId;

  @override
  State<RecipeInfoScreen> createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen> {
  @override
  void initState() {
    super.initState();
    final recipes = BlocProvider.of<BaseRecipeListCubit>(context).state.recipes;
    final recipeBloc = BlocProvider.of<BaseRecipeInfoCubit>(context);
    recipeBloc.findRecipe(id: widget.recipeId, recipes: recipes).then((value) =>
        BlocProvider.of<BaseCommentsCubit>(context)
            .loadComments(recipeBloc.state.recipe));
  }

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
                IconButton(
                  icon: const Icon(Icons.campaign),
                  onPressed: () {
                    log('campaign tapped');
                  },
                )
              ],
            ),
            body: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
              builder: (context, state) {
                return switch (state.searchStatus) {
                  RecipeSearchStatus.initial ||
                  RecipeSearchStatus.inProgress =>
                    const Center(child: CircularProgressIndicator()),
                  RecipeSearchStatus.notFound => const Center(
                      child: Text('Не удалось найти данные о рецепте')),
                  RecipeSearchStatus.found =>
                    ScreenBodyRecipeFound(recipe: state.recipe!)
                };
              },
            )));
  }
}
