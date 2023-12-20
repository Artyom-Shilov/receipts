import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'recipe_info_state.freezed.dart';

enum RecipeInfoStatus {
  success,
  error,
}

@freezed
class RecipeInfoState with _$RecipeInfoState {
  const factory RecipeInfoState(
      {required RecipeInfoStatus status,
       required Recipe recipe,
       @Default('') String message
      }) = _RecipeInfoState;
}