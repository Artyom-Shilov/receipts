import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/favourite/controllers/favourite_recipes_state.dart';

abstract interface class BaseFavouriteRecipesCubit extends Cubit<FavouriteRecipesState> {
  BaseFavouriteRecipesCubit(super.initialState);

  List<Recipe> get favouriteRecipes;
}