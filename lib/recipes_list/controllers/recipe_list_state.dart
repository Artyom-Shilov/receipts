import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'recipe_list_state.freezed.dart';

enum RecipeListLoadingStatus {
  initial,
  inProgress,
  done,
  error;
}

@freezed
class RecipeListState with _$RecipeListState {
  const factory RecipeListState(
      {required RecipeListLoadingStatus loadingStatus,
      required List<Recipe> recipes,
      @Default('') String message,
      }) = _RecipeListState;
}
