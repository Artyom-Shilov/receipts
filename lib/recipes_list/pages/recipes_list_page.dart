import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/widgets/recipe_sliver_list.dart';

class RecipesListPage extends StatelessWidget {
  const RecipesListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipesListCubit = BlocProvider.of<BaseRecipeListCubit>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.horizontal1,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.greyBackground,
              toolbarHeight: MediaQuery.of(context).size.height * 0.05,
            ),
            RecipeSliverList(recipes: recipesListCubit.recipes),
            const CommonPersistentHeader(
              maxExtent: 20,
              color: AppColors.greyBackground,
            ),
          ],
        ),
      ),
    );
  }
}
