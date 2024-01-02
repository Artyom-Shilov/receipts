import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'local_ingredient.freezed.dart';
part 'local_ingredient.g.dart';

@freezed
class LocalIngredient with _$LocalIngredient {
  @HiveType(typeId: 1, adapterName: 'LocalIngredientAdapter')
  const factory LocalIngredient(
  {
    @HiveField(0)required int id,
    @HiveField(1)required String count,
    @HiveField(2)required String name,
    @HiveField(3)required String measureUnit
  }) = _LocalIngredient;
}