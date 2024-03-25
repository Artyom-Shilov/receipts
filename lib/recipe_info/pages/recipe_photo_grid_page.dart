import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/util/util_logic.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_photo_view_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

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
    final recipePhotoCubit = BlocProvider.of<BaseRecipePhotoViewCubit>(context);
    final status = recipePhotoCubit.state.status;
    final navigation = BlocProvider.of<BaseNavigationCubit>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleTextStyle: const TextStyle(
            color: AppColors.main, fontSize: 20, fontWeight: FontWeight.w400),
        title: const Text(RecipeInfoTexts.photoGridPageAppBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, mainAxisSpacing: 10, crossAxisSpacing: 10),
            itemCount: recipePhotoCubit.recipe.userPhotos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: status == RecipePhotoViewStatus.viewing
                      ? () => navigation.toPhotoCarousel(
                          recipePhotoCubit.recipe, index)
                      : () => navigation.toPhotoCommenting(
                          recipePhotoCubit.recipe.userPhotos[index],
                          recipePhotoCubit.recipe),
                  child: Image.memory(
                      recipePhotoCubit.recipe.userPhotos[index].photoBites,
                      width: MediaQuery.sizeOf(context).width / 4,
                      fit: BoxFit.cover));
            }),
      ),
    );
  }
}
