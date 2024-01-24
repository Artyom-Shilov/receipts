import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/favourite/controllers/favourite_recipes_state.dart';

class FavouriteRecipesCubit extends Cubit<FavouriteRecipesState>
    implements BaseFavouriteRecipesCubit {
  FavouriteRecipesCubit(BaseRecipeRepository repository)
      : _repository = repository,
        super(const FavouriteRecipesState(
            status: FavouriteRecipesStatus.init)) {
    _recipesSubscription = _repository.recipesStream.listen((recipes) {
      final favourite = recipes
          .where((element) => element.favouriteStatus.isFavourite)
          .toList();
      favourite.isNotEmpty
          ? emit(state.copyWith(
              favouriteRecipes: favourite,
              status: FavouriteRecipesStatus.inStock))
          : emit(state.copyWith(status: FavouriteRecipesStatus.noFavouriteRecipes));
    });
  }

  final BaseRecipeRepository _repository;
  StreamSubscription<List<Recipe>>? _recipesSubscription;

  @override
  List<Recipe> get favouriteRecipes => state.favouriteRecipes;

  @override
  Future<void> close() {
    _recipesSubscription?.cancel();
    return super.close();
  }
}
