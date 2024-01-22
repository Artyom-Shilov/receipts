import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

part 'recipe_branch_state.freezed.dart';

@freezed
class RecipeBranchState with _$RecipeBranchState {
  const factory RecipeBranchState({
    @Default(Pages.recipeList) Pages currentPage,
    Recipe? selectedRecipe,
    RecipePhotoViewStatus? photoViewMode,
    int? openedIndexInCarousel,
    @Default(List<UserRecipePhoto>) photosInCarousel,
    UserRecipePhoto? photoToComment,
  }
  ) = _RecipeBranchState;

}
