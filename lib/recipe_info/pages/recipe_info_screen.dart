import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';
import 'package:receipts/recipe_info/controllers/base_comments_controller.dart';
import 'package:receipts/recipe_info/controllers/base_cooking_step_controller.dart';
import 'package:receipts/recipe_info/controllers/cooking_step_controller.dart';
import 'package:receipts/recipe_info/widgets/widgets.dart';

class RecipeInfoScreen extends StatefulWidget {
  const RecipeInfoScreen({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  State<RecipeInfoScreen> createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen> {
  late Future<void> commentsUpdate;

  @override
  void initState() {
    super.initState();
    commentsUpdate = context
        .read<BaseCommentsController>()
        .fetchCommentsOfRecipe(widget.recipe);
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const CommonPersistentHeader(
                  maxExtent: 25,
                  color: Colors.white,
                ),
                SliverToBoxAdapter(
                  child: RecipeTopColumn(recipe: widget.recipe),
                ),
                const SliverToBoxAdapter(
                    child: RecipeInfoSectionTitle(
                        text: RecipeInfoTexts.ingredientsSectionTitle)),
                SliverToBoxAdapter(
                  child: IngredientsCard(
                    ingredients: widget.recipe.ingredients,
                  ),
                ),
                const SliverToBoxAdapter(
                    child: RecipeInfoSectionTitle(
                        text: RecipeInfoTexts.stepsSectionTitle)),
                SliverList.separated(
                    itemBuilder: (context, index) => ChangeNotifierProvider(
                          create: (context) {
                            BaseCookingStepController controller =
                                CookingStepController();
                            return controller;
                          },
                          child: CookingStepRow(
                            step: widget.recipe.steps[index],
                            index: index + 1,
                          ),
                        ),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                    itemCount: widget.recipe.steps.length),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: Insets.vertical1),
                    child: ControlButton(
                      backgroundColor: AppColors.main,
                      borderColor: AppColors.main,
                      text: const Text(
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
                if (context.read<BaseAuthController>().isLoggedIn) ...[
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
                  FutureBuilder(
                      future: commentsUpdate,
                      builder: (context, snapshot) {
                        return snapshot.connectionState == ConnectionState.done
                            ? const CommentsList()
                            : const SliverToBoxAdapter(
                                child:
                                    Center(child: CircularProgressIndicator()));
                      }),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: Insets.vertical1,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: CommentInputField(recipe: widget.recipe),
                  ),
                ],
                CommonPersistentHeader(
                  maxExtent: MediaQuery.of(context).size.height * 0.07,
                  color: Colors.white,
                )
              ],
            ),
          )),
    );
  }
}
