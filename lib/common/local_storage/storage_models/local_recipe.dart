import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/storage_models/local_cooking_step.dart';
import 'package:receipts/common/local_storage/storage_models/local_ingredient.dart';
import 'package:receipts/common/local_storage/storage_models/local_user_recipe_photo.dart';

part 'local_recipe.freezed.dart';
part 'local_recipe.g.dart';


@Freezed(makeCollectionsUnmodifiable: false)
class LocalRecipe with _$LocalRecipe {
  @HiveType(typeId: 3, adapterName: 'LocalRecipeAdapter')
  const factory LocalRecipe(
      {@HiveField(1) required int id,
      @HiveField(2) required String name,
      @HiveField(3) required String duration,
      @HiveField(4) required List<LocalIngredient> ingredients,
      @HiveField(5) required List<LocalCookingStep> steps,
      @HiveField(6) required Uint8List photoBytes,
      @HiveField(7) required List<LocalUserRecipePhoto> userPhotos,
      @HiveField(8) required int likesNumber,
      }) = _Recipe;
}
