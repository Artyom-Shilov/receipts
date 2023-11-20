import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/services/base_recipe_service.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

import 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState> implements BaseRecipeInfoCubit {

  RecipeInfoCubit({required BaseRecipeService service, required Recipe recipe })
      : _service = service,
        super(RecipeInfoState(status: RecipeInfoStatus.success, recipe: recipe));

  final BaseRecipeService _service;

  @override
  Future<void> changeFavouriteStatus() async {
    Recipe changedInfo;
    try {
      bool newValue = !state.recipe.isFavourite;
      changedInfo = state.recipe.copyWith(isFavourite: newValue);
    } catch (e) {
      emit(state.copyWith(status: RecipeInfoStatus.error));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
    await _service.saveRecipeInfo(changedInfo);
  }

  @override
  Future<void> saveComment(Comment comment) async {
    Recipe changedInfo;
    try {
      List<Comment> commentList = [...comments];
      commentList.add(comment);
      changedInfo = state.recipe.copyWith(comments: commentList);
    } catch (e) {
      emit(state.copyWith(status: RecipeInfoStatus.error));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
    await _service.saveRecipeInfo(changedInfo);
  }

  @override
  Future<void> changeCookingStepStatus(int index) async {
    Recipe changedInfo;
    try {
      final newStepList = [...state.recipe.steps];
      CookingStep changingCookingStep = newStepList[index];
      bool newValue = !changingCookingStep.isDone;
      changingCookingStep = changingCookingStep.copyWith(isDone: newValue);
      newStepList[index] = changingCookingStep;
      changedInfo = state.recipe.copyWith(steps: newStepList);
    } catch (e) {
      emit(state.copyWith(status: RecipeInfoStatus.error));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
    await _service.saveRecipeInfo(changedInfo);
  }


  @override
  List<Comment> get comments => state.recipe.comments;

  @override
  bool get isFavourite => state.recipe.isFavourite;

  @override
  Recipe get recipe => state.recipe;
}
