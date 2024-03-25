import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/widgets/widgets.dart';


class RecipeTopColumn extends StatelessWidget {
  const RecipeTopColumn({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<BaseAuthCubit>(context);
    final navigator = BlocProvider.of<BaseNavigationCubit>(context);
    return BlocProvider<BaseHeartAnimationCubit>(
      create: (context) => HeartAnimationCubit(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  recipe.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              if (authCubit.isLoggedIn) const AnimatedHeart()
            ],
          ),
          const SizedBox(height: Insets.vertical1),
          BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
            buildWhen: (prev, next) =>
                prev.recipe.userPhotos.length != next.recipe.userPhotos.length,
            builder: (context, state) =>
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 10),
              Text(
                recipe.duration,
                style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                child: const Icon(Icons.add_a_photo, size: 20),
                onTap: () {
                  navigator.toCamera(recipe);
                },
              ),
              if (state.recipe.userPhotos.isNotEmpty) ...[
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    navigator.toUserPhotoGrid(
                        state.recipe, RecipePhotoViewStatus.viewing);
                  },
                  child: const Icon(Icons.view_comfy_alt, size: 20),
                )
              ]
            ]),
          ),
          const SizedBox(height: Insets.vertical1),
          LayoutBuilder(builder: (context, constraints) {
            return Stack(children: [
                  SizedBox(
                      width: double.infinity,
                      height:
                      constraints.maxWidth < SizeBreakPoints.phoneLandscape
                          ? MediaQuery.of(context).size.longestSide * 0.25
                          : MediaQuery.of(context).size.longestSide * 0.50,
                      child: Image.memory(recipe.photoBytes, fit: BoxFit.cover)),
                  if (authCubit.isLoggedIn)
                    Positioned(
                      bottom: 20,
                      right: 0,
                      child: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
                    buildWhen: (prev, next) =>
                        prev.recipe.likesNumber != next.recipe.likesNumber,
                    builder: (context, state) => const AnimatedBookmark(
                        color: AppColors.accent,
                        number: 1,
                        height: 25,
                        width: 60),
                  ),
                ),
            ]
            );
          })
        ],
      ),
    );
  }
}
