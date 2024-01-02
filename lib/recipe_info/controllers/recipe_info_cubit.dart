import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

import 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState>
    implements BaseRecipeInfoCubit {

  RecipeInfoCubit({required BaseRecipeRepository repository, required Recipe recipe})
      : _repository = repository,
        super(RecipeInfoState(status: RecipeInfoStatus.success, recipe: recipe)) {
    _recipeSubscription = _repository.recipes.listen((event) {
      if (event.firstWhere((element) => element.id == state.recipe.id) != state.recipe) {
        emit(state.copyWith(recipe: event.firstWhere((element) => element.id == state.recipe.id)));
      }
    });
  }

  final BaseRecipeRepository _repository;
  StreamSubscription<List<Recipe>>? _recipeSubscription;


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
    await _repository.saveRecipeInfo(changedInfo);
  }

  @override
  Future<void> saveComment(Comment comment) async {
    Recipe changedInfo;
    try {
      List<Comment> commentList = [...comments];
      commentList.add(comment);
      changedInfo = state.recipe.copyWith(comments: commentList);
    } catch (e) {
      emit(state.copyWith(
          status: RecipeInfoStatus.error,
          message: ErrorMessages.changeRecipeInfo));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
    await _repository.saveRecipeInfo(changedInfo);
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
      emit(state.copyWith(
          status: RecipeInfoStatus.error,
          message: ErrorMessages.changeRecipeInfo));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
    await _repository.saveRecipeInfo(changedInfo);
  }

  @override
  List<Comment> get comments => state.recipe.comments;

  @override
  bool get isFavourite => state.recipe.isFavourite;

  @override
  Recipe get recipe => state.recipe;

  @override
  List<UserRecipePhoto> get userPhotos => state.recipe.userPhotos;

  @override
  Future<void> close() {
    _recipeSubscription?.cancel();
    return super.close();
  }
}
