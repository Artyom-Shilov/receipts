import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';

abstract interface class BaseRecipeInfoCubit extends Cubit<RecipeInfoState> {
  BaseRecipeInfoCubit()
      : super(const RecipeInfoState(searchStatus: RecipeSearchStatus.initial));

  void findRecipe({required String id, required List<Recipe> recipes});

  void saveComment({required Comment comment, required User user});
}
