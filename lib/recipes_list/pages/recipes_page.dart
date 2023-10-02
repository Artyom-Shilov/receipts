import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';
import 'package:receipts/recipes_list/controllers/base_recipes_controller.dart';
import 'package:receipts/recipes_list/widgets/recipe_sliver_list.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {

  late Future<void> recipesFuture;

  @override
  void initState() {
    super.initState();
    recipesFuture = context.read<BaseRecipesController>().initRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final recipes = context.read<BaseRecipesController>().recipesList;
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