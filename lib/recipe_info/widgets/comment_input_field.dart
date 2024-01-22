import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class CommentInputField extends HookWidget {
  final Recipe recipe;

  const CommentInputField({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final TextEditingController textController;
    useEffect(() {
      textController = TextEditingController();
      return () => textController.dispose();
    });
    return TextField(
      controller: textController,
      maxLines: 2,
      textInputAction: kIsWeb ? TextInputAction.search : TextInputAction.done,
      decoration: InputDecoration(
        hintText: RecipeInfoTexts.commentInputHint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.main)),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.main)),
        suffixIcon: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
          buildWhen: (prev, next) =>
              prev.recipe.userPhotos.length != next.recipe.userPhotos.length,
          builder: (context, state) => GestureDetector(
            onTap: () {
              /*GoRouter.of(context).go(
                '/${AppTabs.recipes}'
                '/${RecipesRouteNames.recipe}'
                '/${state.recipe.id}'
                '/${RecipesRouteNames.photoView}',
                extra: {
                  ExtraKeys.recipe: state.recipe,
                  ExtraKeys.recipePhotoViewMode : RecipePhotoViewStatus.choosingCommentPhoto
                },
              );*/
            },
            child: const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Icon(
                  Icons.photo,
                  color: AppColors.main,
                )),
          ),
        ),
      ),
      onSubmitted: (text) async {
        final user = BlocProvider.of<BaseAuthCubit>(context).state.user!;
        final recipe = BlocProvider.of<BaseRecipeInfoCubit>(context).recipe;
        textController.clear();
        await BlocProvider.of<BaseRecipeInfoCubit>(context)
            .saveComment(user: user, recipe: recipe, text: text, photo: recipe.photoToSendComment);
      },
    );
  }
}
