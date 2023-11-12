import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'recipe_info_state.freezed.dart';

enum RecipeSearchStatus {
  initial,
  inProgress,
  found,
 /* notFound,
  error,*/
}

@freezed
class RecipeInfoState with _$RecipeInfoState {
  const factory RecipeInfoState(
      {required RecipeSearchStatus searchStatus,
      Recipe? recipe}) = _RecipeInfoState;
}