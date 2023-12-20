import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_recipe_step.freezed.dart';
part 'network_recipe_step.g.dart';

@freezed
class NetworkRecipeStep with _$NetworkRecipeStep {
  const factory NetworkRecipeStep(
      {required int id,
        required String name,
        required int duration}) = _NetworkRecipeStep;

  factory NetworkRecipeStep.fromJson(Map<String, dynamic> json) =>
      _$NetworkRecipeStepFromJson(json);
}
