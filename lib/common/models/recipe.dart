import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';

import 'comment.dart';

part 'recipe.g.dart';

part 'recipe.freezed.dart';

@freezed
@freezed
class Recipe  with _$Recipe {
  const factory Recipe(
  {
    required String id,
    required String image,
    required String cookingTime,
    required String title,
    @Default([]) List<Ingredient> ingredients,
    @Default([]) List<CookingStep> steps,
    @Default([]) List<Comment> comments,
    @Default(false) bool isFavourite
}
      ) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}

