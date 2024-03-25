import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_favourite.freezed.dart';

part 'network_favourite.g.dart';

@freezed
class NetworkFavourite with _$NetworkFavourite {
  const factory NetworkFavourite({
    required int id,
    required LinkedToFavouriteRecipe recipe,
    required LinkedToFavouriteUser user,
  }) = _NetworkFavourite;

  factory NetworkFavourite.fromJson(Map<String, dynamic> json) =>
      _$NetworkFavouriteFromJson(json);
}

@freezed
class LinkedToFavouriteRecipe with _$LinkedToFavouriteRecipe {
  const factory LinkedToFavouriteRecipe({required int id}) =
      _LinkedToFavouriteRecipe;

  factory LinkedToFavouriteRecipe.fromJson(Map<String, dynamic> json) =>
      _$LinkedToFavouriteRecipeFromJson(json);
}

@freezed
class LinkedToFavouriteUser with _$LinkedToFavouriteUser {
  const factory LinkedToFavouriteUser({required int id}) =
      _LinkedToFavouriteUser;

  factory LinkedToFavouriteUser.fromJson(Map<String, dynamic> json) =>
      _$LinkedToFavouriteUserFromJson(json);
}
