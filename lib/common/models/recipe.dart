import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';

import 'comment.dart';

part 'recipe.freezed.dart';

@Freezed(makeCollectionsUnmodifiable: false)
class Recipe with _$Recipe {
  const factory Recipe(
      {
          required int id,
          required String name,
          required String duration,
          required String photoUrl,
          required List<Ingredient> ingredients,
          required List<CookingStep> steps,
          required List<Comment> comments,
          @Default(false) bool isFavourite,
          required Uint8List photoBytes,
          required List<UserRecipePhoto> userPhotos,
      }) = _Recipe;
}
