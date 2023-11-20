import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.g.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient(
  {required String title,
   required String quantity
  }
      ) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) =>
      _$IngredientFromJson(json);
}