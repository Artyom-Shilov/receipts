import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/pages/recipe_error_page.dart';
import 'package:receipts/recipe_info/pages/recipe_page.dart';

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
                    RecipeInfoStatus.success || RecipeInfoStatus.commentProgress
                  => RecipePage(recipe: state.recipe),
                    RecipeInfoStatus.error =>
                      RecipeErrorPage(recipe: state.recipe),
                  };
                },
              )));
  }
}
