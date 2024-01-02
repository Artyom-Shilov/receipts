import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient(
  {
    required int id,
    required String count,
    required String name,
    required String measureUnit
  }) = _Ingredient;
}