import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'local_cooking_step.freezed.dart';
part 'local_cooking_step.g.dart';

@freezed
class LocalCookingStep with _$LocalCookingStep {
  @HiveType(typeId: 2, adapterName: 'LocalCookingStepAdapter')
  const factory LocalCookingStep(
      {
        @HiveField(0)required int id,
        @HiveField(1)required String number,
        @HiveField(2)required String description,
        @HiveField(3)required String duration,
        @HiveField(4, defaultValue: false) @Default(false) bool isDone,
      }) = _LocalCookingStep;
}
