import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step_state.freezed.dart';

@freezed
class RecipeStepState with _$RecipeStepState{
  const factory RecipeStepState({
    required bool isDone
}) = _RecipeStepState;
}