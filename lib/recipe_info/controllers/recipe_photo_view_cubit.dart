import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_photo_view_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class RecipePhotoViewCubit extends Cubit<RecipePhotoViewState>
    implements BaseRecipePhotoViewCubit {
  RecipePhotoViewCubit(
      {required Recipe recipe, required RecipePhotoViewStatus status, required BaseRecipeRepository recipeRepository})
      : _repository = recipeRepository,
        super(RecipePhotoViewState(recipe: recipe, status: status));

  final BaseRecipeRepository _repository;

  @override
  Future<void> chooseCommentPhoto(Uint8List photo) async {
    Recipe changedInfo = state.recipe.copyWith(photoToSendComment: photo);
    await _repository.saveRecipeInfo(changedInfo);
    emit(state.copyWith(recipe: changedInfo));
  }

  @override
  void viewPhoto() {
    emit(state.copyWith(status: RecipePhotoViewStatus.viewing));
  }

  @override
  void viewPhotoWithDetections() {
    emit(state.copyWith(status: RecipePhotoViewStatus.viewingWithDetections));
  }

  @override
  Recipe get recipe => state.recipe;
}