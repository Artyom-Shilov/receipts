import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/storage_models/local_cooking_step.dart';
import 'package:receipts/common/local_storage/storage_models/local_ingredient.dart';
import 'package:receipts/common/local_storage/storage_models/local_user_recipe_photo.dart';

import 'local_comment.dart';

part 'local_recipe.freezed.dart';
part 'local_recipe.g.dart';


@Freezed(makeCollectionsUnmodifiable: false)
class LocalRecipe with _$LocalRecipe {
  @HiveType(typeId: 3, adapterName: 'LocalRecipeAdapter')
  const factory LocalRecipe(
      {@HiveField(1) required int id,
      @HiveField(2) required String name,
      @HiveField(3) required String duration,
      @HiveField(4) required String photoUrl,
      @HiveField(5) required List<LocalIngredient> ingredients,
      @HiveField(6) required List<LocalCookingStep> steps,
      @HiveField(7) required List<LocalComment> comments,
      @HiveField(9) required Uint8List photoBytes,
      @HiveField(10) required List<LocalUserRecipePhoto> userPhotos,
      @HiveField(11) required int likesNumber,
      }) = _Recipe;
}
