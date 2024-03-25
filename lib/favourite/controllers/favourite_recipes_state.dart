import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'favourite_recipes_state.freezed.dart';

enum FavouriteRecipesStatus {
  init,
  noFavouriteRecipes,
  inStock
}

@freezed
class FavouriteRecipesState with _$FavouriteRecipesState {
  const factory FavouriteRecipesState(
  { required FavouriteRecipesStatus status,
    @Default([]) List<Recipe> favouriteRecipes}) = _FavouriteRecipesState;
}
