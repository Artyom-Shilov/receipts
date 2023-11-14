import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/recipe/recipe_info_state.dart';

abstract interface class BaseRecipeInfoCubit extends Cubit<RecipeInfoState> {
  BaseRecipeInfoCubit(super.initialState);

  Future<void> findRecipe({required String id, required List<Recipe> recipes});

}
