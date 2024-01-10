import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/common/widgets/bookmark.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_state.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipeIndex}) : super(key: key);
  final int recipeIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseRecipeListCubit, RecipeListState>(
      buildWhen: (prev, next) =>
          prev.recipes[recipeIndex] != next.recipes[recipeIndex],
      builder: (context, state) {
        final recipe = state.recipes[recipeIndex];
        return GestureDetector(
          onTap: () {
            GoRouter.of(context).go(
                '/${AppTabs.recipes}/${RecipesRouteNames.recipe}/${recipe.id}',
                extra: {ExtraKeys.recipe: recipe});
          },
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromRGBO(49, 146, 146, 0.1),
                    blurStyle: BlurStyle.normal,
                    blurRadius: 4,
                    spreadRadius: 2,
                    offset: Offset(0, 4))
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 8,
                  child: BlocBuilder<BaseAuthCubit, AuthState>(
                    builder: (context, state) => Stack(children: [
                      Image.memory(
                        recipe.photoBytes,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.longestSide * 0.15,
                      ),
                      if (recipe.favouriteStatus.isFavourite  &&
                          state.status == AuthStatus.loggedIn)
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: Bookmark(
                              color: AppColors.accent,
                              number: recipe.likesNumber,
                              height: 17,
                              width: 40),
                        )
                    ]),
                  ),
                ),
                const Spacer(flex: 1),
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.name,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(Icons.access_time, size: 16),
                            Expanded(
                              child: Text(
                                '   ${recipe.duration}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.accent),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(flex: 1)
              ],
            ),
          ),
        );
      },
    );
  }
}
