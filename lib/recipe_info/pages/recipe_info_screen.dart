import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:receipts/recipe_info/pages/recipe_error_page.dart';
import 'package:receipts/recipe_info/pages/recipe_page.dart';

class RecipeInfoScreen extends StatelessWidget {
  const RecipeInfoScreen({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    print('info rebuild');
    print(recipe.name);
    print('info rebuild');
    return BlocProvider<BaseRecipeInfoCubit>(
      create: (context) => RecipeInfoCubit(
          repository:
          GetIt.instance.get<BaseRecipeRepository>(),
          networkClient:
          GetIt.instance.get<BaseNetworkRecipeClient>(),
          recipe: recipe),
      child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                titleTextStyle: const TextStyle(
                    color: AppColors.main,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
                title: const Text(RecipeInfoTexts.mainAppBarTitle),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.campaign),
                      onPressed: () {
                        log('campaign tapped');
                      })
                ],
              ),
              body: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
                buildWhen: (prev, next) => prev.status != next.status,
                builder: (context, state) {
                  return switch (state.status) {
                    RecipeInfoStatus.success || RecipeInfoStatus.commentProgress => RecipePage(recipe: state.recipe),
                    RecipeInfoStatus.error =>
                      RecipeErrorPage(recipe: state.recipe),
                  };
                },
              ))),
    );
  }
}
