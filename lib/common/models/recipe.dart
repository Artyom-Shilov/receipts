import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';

import 'comment.dart';

part 'recipe.g.dart';

part 'recipe.freezed.dart';

@freezed
@freezed
class Recipe with _$Recipe {
  @HiveType(typeId: 3, adapterName: 'RecipeAdapter')
  const factory Recipe(
      {@HiveField(1) required int id,
      @HiveField(2) required String name,
      @HiveField(3) required String duration,
      @HiveField(4) required String photo,
      @HiveField(5) required List<Ingredient> ingredients,
      @HiveField(6) required List<CookingStep> steps,
      @HiveField(7) required List<Comment> comments,
      @HiveField(8, defaultValue: false)
      @Default(false)
      bool isFavourite}) = _Recipe;
}
