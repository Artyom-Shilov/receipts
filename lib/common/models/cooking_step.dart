import 'package:freezed_annotation/freezed_annotation.dart';

part 'cooking_step.g.dart';
part 'cooking_step.freezed.dart';

@freezed
class CookingStep with _$CookingStep {
  const factory CookingStep(
      {
        required String description,
        required String duration,
        @Default(false) bool isDone,
      }) = _CookingStep;

  factory CookingStep.fromJson(Map<String, dynamic> json) =>
      _$CookingStepFromJson(json);
}
