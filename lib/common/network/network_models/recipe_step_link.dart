
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step_link.freezed.dart';
part 'recipe_step_link.g.dart';


@freezed
class RecipeStepLink with _$RecipeStepLink {
  const factory RecipeStepLink({
    required int id,
    required int number,
    required LinkedRecipe recipe,
    required LinkedStep step,
}) = _RecipeStepLink;

  factory RecipeStepLink.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepLinkFromJson(json);
}

@freezed
class LinkedRecipe with _$LinkedRecipe {
  const factory LinkedRecipe(
  {required int id}
      ) = _LinkedRecipe;

  factory LinkedRecipe.fromJson(Map<String, dynamic> json) =>
      _$LinkedRecipeFromJson(json);
}

@freezed
class LinkedStep with _$LinkedStep {
  const factory LinkedStep(
  {required int id}
      ) = _LinkedStep;

  factory LinkedStep.fromJson(Map<String, dynamic> json) =>
      _$LinkedStepFromJson(json);
}
