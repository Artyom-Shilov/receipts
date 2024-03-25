import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/recipe_info/widgets/widgets.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({Key? key, required this.recipe})
      : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          const CommonPersistentHeader(
            maxExtent: 25,
            color: Colors.white,
          ),
          SliverToBoxAdapter(
            child: RecipeTopColumn(recipe: recipe),
          ),
          const SliverToBoxAdapter(
              child: RecipeInfoSectionTitle(
                  text: RecipeInfoTexts.ingredientsSectionTitle)),
          SliverToBoxAdapter(
            child: IngredientsCard(
              ingredients: recipe.ingredients,
            ),
          ),
          const SliverToBoxAdapter(
              child: RecipeInfoSectionTitle(
                  text: RecipeInfoTexts.stepsSectionTitle)),
          SliverList.separated(
              key: const ValueKey(#cooking_steps_list),
              itemBuilder: (context, index) =>
                   CookingStepRow(
                      step: recipe.steps[index],
                      index: index + 1),
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemCount: recipe.steps.length),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: Insets.vertical1),
              child: ControlButton(
                backgroundColor: AppColors.main,
                borderColor: AppColors.main,
                child: const Text(
                  RecipeInfoTexts.startCookingButton,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                onPressed: () {
                  log('start cooking pressed');
                },
              ),
            ),
          ),
          if (BlocProvider.of<BaseAuthCubit>(context).isLoggedIn) ...[
            const SliverToBoxAdapter(
              child: SizedBox(
                height: Insets.vertical1,
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: Insets.vertical1,
              ),
            ),
            const CommentsList(),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: Insets.vertical1,
              ),
            ),
            SliverToBoxAdapter(
              child: CommentInputField(recipe: recipe),
            ),
          ],
          CommonPersistentHeader(
            maxExtent: MediaQuery.of(context).size.height * 0.07,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
