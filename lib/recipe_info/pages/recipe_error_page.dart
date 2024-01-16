import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/pages/recipe_page.dart';

class RecipeErrorPage extends HookWidget {
  const RecipeErrorPage({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final recipesInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    useEffect(() {
      Future.delayed(
          Duration.zero,
              () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                content: Text(recipesInfoCubit.state.message),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.done, color: AppColors.accent),
                    onPressed: () {
                      final router = GoRouter.of(context);
                      router.pop();
                      BlocProvider.of<BaseAuthCubit>(context).logOut();
                      router.go('/${AppTabs.recipes}');
                    },
                  ),
                ],
              )));
      return null;
    });
    return RecipePage(recipe: recipe);
  }
}
