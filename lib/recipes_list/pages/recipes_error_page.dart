import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/pages/recipes_list_page.dart';
import 'package:receipts/recipes_list/widgets/recipe_sliver_list.dart';

class RecipesErrorPage extends HookWidget {
  const RecipesErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipesListCubit = BlocProvider.of<BaseRecipeListCubit>(context);
    final navigation = BlocProvider.of<BaseNavigationCubit>(context);
    useEffect(() {
      Future.delayed(
          Duration.zero,
          () => showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                    title: Center(
                        child: Text(recipesListCubit.state.message,
                            style: const TextStyle(fontSize: 14))),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.done, color: AppColors.accent),
                        onPressed: () {
                          BlocProvider.of<BaseAuthCubit>(context).logOut();
                      navigation.toRecipeList();
                    },
                  ),
                ],
              )));
      return null;
    });
    return RecipesListPage(sliverList: RecipeSliverList(recipes: recipesListCubit.recipes));
  }
}
