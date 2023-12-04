import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_ingredient.freezed.dart';

part 'network_ingredient.g.dart';

@freezed
class NetworkIngredient with _$NetworkIngredient {
  const factory NetworkIngredient(
      {required int id,
      required String name,
      required double caloriesForUnit,
      required LinkedMeasureUnit measureUnit}) = _NetworkIngredient;

  factory NetworkIngredient.fromJson(Map<String, dynamic> json) =>
      _$NetworkIngredientFromJson(json);
}

@freezed
class LinkedMeasureUnit with _$LinkedMeasureUnit {
  const factory LinkedMeasureUnit({required int id}) = _LinkedMeasureUnit;

  factory LinkedMeasureUnit.fromJson(Map<String, dynamic> json) =>
      _$LinkedMeasureUnitFromJson(json);
}
