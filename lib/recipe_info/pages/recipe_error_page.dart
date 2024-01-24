import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
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
                      BlocProvider.of<BaseAuthCubit>(context).logOut();
                      BlocProvider.of<BaseNavigationCubit>(context).toLogin();
                    },
                  ),
                ],
              )));
      return null;
    });
    return RecipePage(recipe: recipe);
  }
}
