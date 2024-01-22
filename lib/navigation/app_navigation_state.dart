import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/favourite_branch_state.dart';
import 'package:receipts/navigation/recipe_branch_state.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';

part 'app_navigation_state.freezed.dart';

enum Pages {
  recipeList,
  recipeInfo,
  camera,
  userPhotosGrid,
  userPhotosCarousel,
  userPhotoCommenting,
  favouriteList,
  profile,
  login
}

enum Branches {
  recipes,
  login,
  profile,
  favourite,
}

@freezed
class AppNavigationState with _$AppNavigationState {
  const factory AppNavigationState({
    required Branches currentBranch,
    required FavouriteBranchState favouriteBranchState,
    required RecipeBranchState recipeBranchState,
    @Default(false) bool isBranchChanged,
  }) = _AppNavigationState;
}