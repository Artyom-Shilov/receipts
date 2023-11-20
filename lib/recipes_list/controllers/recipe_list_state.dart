import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'recipe_list_state.freezed.dart';

enum RecipeListStatus {
  initial,
  inProgress,
  success,
  error;
}

@freezed
class RecipeListState with _$RecipeListState {
  const factory RecipeListState(
      {required RecipeListStatus status,
      required List<Recipe> recipes,
      }) = _RecipeListState;
}
