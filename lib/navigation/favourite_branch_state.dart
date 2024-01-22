import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

part 'favourite_branch_state.freezed.dart';

@freezed
class FavouriteBranchState with _$FavouriteBranchState {
  const factory FavouriteBranchState(
  {
    @Default(Pages.favouriteList) Pages currentPage,
    Recipe? selectedRecipe,
    RecipePhotoViewStatus? photoViewMode,
    int? openedIndexInCarousel,
    @Default(List<UserRecipePhoto>) photosInCarousel,
    UserRecipePhoto? photoToComment,
  }
      ) = _FavouriteBranchState;

}
