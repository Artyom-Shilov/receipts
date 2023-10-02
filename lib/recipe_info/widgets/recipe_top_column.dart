import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_favourite_status_controller.dart';

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
            Text(
              recipe.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (context.read<BaseAuthController>().isLoggedIn)
              Consumer<BaseFavouriteStatusController>(
                builder: (context, controller, _) => IconButton(
                  icon: const Icon(Icons.favorite),
                  color:
                      context.read<BaseFavouriteStatusController>().isFavourite
                          ? Colors.red
                          : Colors.black,
                  onPressed: () {
                    context
                        .read<BaseFavouriteStatusController>()
                        .changeFavouriteStatus();
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
