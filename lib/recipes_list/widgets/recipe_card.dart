import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_router.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.goNamed(AppRouteNames.recipe.name, pathParameters: {
          AppPathParameters.tab.name: AppTabs.recipes.name,
          AppPathParameters.recipeId.name: recipe.id
        });
      },
      child: Container(
        height: MediaQuery.of(context).size.longestSide * 0.15,
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
            Image.asset(
              recipe.image,
              fit: BoxFit.cover,
            ),
            const Spacer(
              flex: 1,
            ),
            Flexible(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      Text(
                        '   ${recipe.cookingTime}',
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: AppColors.accent),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}
