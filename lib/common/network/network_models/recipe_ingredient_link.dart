import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient_link.freezed.dart';
part 'recipe_ingredient_link.g.dart';

@freezed
class RecipeIngredientLink with _$RecipeIngredientLink {
  const factory RecipeIngredientLink(
  {
    required int id,
    required int count,
    required LinkedIngredient ingredient,
    required LinkedRecipe recipe
}
      ) = _RecipeIngredientLink;

  factory RecipeIngredientLink.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientLinkFromJson(json);
}

@freezed
class LinkedIngredient with _$LinkedIngredient {
  const factory LinkedIngredient(
  {required int id}
      ) = _LinkedIngredient;

  factory LinkedIngredient.fromJson(Map<String, dynamic> json) =>
      _$LinkedIngredientFromJson(json);
}

@freezed
class LinkedRecipe with _$LinkedRecipe {
  const factory LinkedRecipe(
  {required int id}
      ) = _LinkedRecipe;

  factory LinkedRecipe.fromJson(Map<String, dynamic> json) =>
      _$LinkedRecipeFromJson(json);
}
