import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';
import 'package:receipts/recipes_list/services/recipe_service.dart';
import 'package:receipts/recipes_list/widgets/recipe_sliver_list.dart';

class RecipeTab extends StatelessWidget {
  const RecipeTab({Key? key}) : super(key: key);

  final RecipeService recipeService = const RecipeService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recipeService.sampleRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final recipes = snapshot.data ?? [];
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.horizontal1,
                ),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.greyBackground,
                      toolbarHeight: MediaQuery.of(context).size.height * 0.05,
                    ),
                    RecipeSliverList(recipes: recipes),
                    const CommonPersistentHeader(
                      maxExtent: 20,
                      color: AppColors.greyBackground,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
