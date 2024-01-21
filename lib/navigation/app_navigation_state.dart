import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'app_navigation_state.freezed.dart';

enum Pages {
  recipeInfo,
  camera,
  userPhotosGrid,
  userPhotosCarousel,
  userPhotoCommenting,
  registration
}

enum Branches {
  recipeList,
  login,
  profile,
  recipesFavourite,
}

@freezed
class AppNavigationState with _$AppNavigationState {
  const factory AppNavigationState({
    required Branches currentBranch,
    Pages? currentPage,
    Recipe? selectedRecipe,
    @Default(false) bool isBranchChanged,
  }) = _AppNavigationState;
}