import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';

class RecipeTopColumn extends StatelessWidget {
  const RecipeTopColumn({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                recipe.title,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            if (BlocProvider.of<BaseAuthCubit>(context).isLoggedIn)
              BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
                builder: (context, state) => IconButton(
                  icon: const Icon(Icons.favorite),
                  color: state.recipe.isFavourite ? Colors.red : Colors.black,
                  onPressed: () {
                    BlocProvider.of<BaseRecipeInfoCubit>(context).changeFavouriteStatus();
                  },
                ),
              )
          ],
        ),
        const SizedBox(
          height: Insets.vertical1,
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 16,
            ),
            Text(
              '  ${recipe.cookingTime}',
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        const SizedBox(
          height: Insets.vertical1,
        ),
        LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
              width: double.infinity,
              height: constraints.maxWidth < SizeBreakPoints.phoneLandscape
                  ? MediaQuery.of(context).size.longestSide * 0.25
                  : MediaQuery.of(context).size.longestSide * 0.50,
              child: Image.asset(recipe.image, fit: BoxFit.cover));
        })
      ],
    );
  }
}
