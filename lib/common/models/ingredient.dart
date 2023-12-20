import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'ingredient.g.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  @HiveType(typeId: 1, adapterName: 'IngredientAdapter')
  const factory Ingredient(
  {
    @HiveField(0)required int id,
    @HiveField(1)required String count,
    @HiveField(2)required String name,
    @HiveField(3)required String measureUnit
  }) = _Ingredient;
}