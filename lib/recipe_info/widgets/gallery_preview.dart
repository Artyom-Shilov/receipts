import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';

class GalleryPreview extends StatelessWidget {
  const GalleryPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState> (
      buildWhen: (previous, next) => next.recipe.userPhotos != previous.recipe.userPhotos,
      builder: (context, state) {
        return SizedBox(
          height: 85,
          child: Row(
            children: [
              Expanded(
                child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 85,
                      child: const Icon(Icons.add_a_photo),
                    ),
                    onTap: () {
                      final recipeInfoCubit =
                      BlocProvider.of<BaseRecipeInfoCubit>(context);
                      GoRouter.of(context).go(
                        '/${AppTabs.recipes}'
                            '/${RecipesRouteNames.recipe}'
                            '/${recipeInfoCubit.recipe.id}'
                            '/${RecipesRouteNames.carousel}',
                        extra: recipeInfoCubit.recipe,
                      );
                    }
        )]
            ),
              ),
          ]
          ),
        );
      },
    );
  }
}
