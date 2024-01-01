import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/util/util_logic.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

class RecipePhotoGridPage extends HookWidget {
  const RecipePhotoGridPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      UtilLogic.fixPortraitUpOrientation();
      return () {
        UtilLogic.unfixOrientation();
      };
    });
    final recipeInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: AppColors.main,
            fontSize: 20,
            fontWeight: FontWeight.w400),
        title: const Text(RecipeInfoTexts.photoGridPageAppBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: recipeInfoCubit.recipe.userPhotos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () => GoRouter.of(context).go(
                        '/${AppTabs.recipes}'
                        '/${RecipesRouteNames.recipe}'
                        '/${recipeInfoCubit.recipe.id}'
                        '/${RecipesRouteNames.photoView}'
                        '/${RecipesRouteNames.carousel}',
                        extra: {
                          ExtraKeys.recipe: recipeInfoCubit.recipe,
                          ExtraKeys.recipePhotoIndex: index
                        },
                      ),
                  child: Image.memory(
                      recipeInfoCubit.recipe.userPhotos[index].photoBites,
                      width: MediaQuery.sizeOf(context).width / 4,
                      fit: BoxFit.cover));
            }),
      ),
    );
  }
}
