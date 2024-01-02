
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step_link.freezed.dart';
part 'recipe_step_link.g.dart';


@freezed
class RecipeStepLink with _$RecipeStepLink {
  const factory RecipeStepLink({
    required int id,
    required int number,
    required LinkedToStepRecipe recipe,
    required LinkedStep step,
}) = _RecipeStepLink;

  factory RecipeStepLink.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepLinkFromJson(json);
}

@freezed
class LinkedToStepRecipe with _$LinkedToStepRecipe {
  const factory LinkedToStepRecipe(
  {
    required int id}
      ) = _LinkedToStepRecipe;

  factory LinkedToStepRecipe.fromJson(Map<String, dynamic> json) =>
      _$LinkedToStepRecipeFromJson(json);
}

@freezed
class LinkedStep with _$LinkedStep {
  const factory LinkedStep(
  {required int id}
      ) = _LinkedStep;

  factory LinkedStep.fromJson(Map<String, dynamic> json) =>
      _$LinkedStepFromJson(json);
}
