import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cooking_step.g.dart';
part 'cooking_step.freezed.dart';

@freezed
class CookingStep with _$CookingStep {
  @HiveType(typeId: 2, adapterName: 'CookingStepAdapter')
  const factory CookingStep(
      {
        @HiveField(0)required int id,
        @HiveField(1)required String number,
        @HiveField(2)required String description,
        @HiveField(3)required String duration,
        @HiveField(4, defaultValue: false) @Default(false) bool isDone,
      }) = _CookingStep;
}
