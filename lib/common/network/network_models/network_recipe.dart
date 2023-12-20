import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_recipe.freezed.dart';
part 'network_recipe.g.dart';

@freezed
class NetworkRecipe with _$NetworkRecipe {
  const factory NetworkRecipe(
      {required int id,
        required String name,
        required int duration,
        required String photo}
      ) = _NetworkRecipe;

  factory NetworkRecipe.fromJson(Map<String, dynamic> json) =>
      _$NetworkRecipeFromJson(json);
}
