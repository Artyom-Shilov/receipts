import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

part 'nested_branch_state.freezed.dart';

@freezed
class NestedBranchState with _$NestedBranchState {
  const factory NestedBranchState(
  {
    required Pages currentPage,
    Recipe? selectedRecipe,
    RecipePhotoViewStatus? photoViewMode,
    int? initIndexInCarousel,
    UserRecipePhoto? photoToComment,
}) = _NestedBranchState;

}
