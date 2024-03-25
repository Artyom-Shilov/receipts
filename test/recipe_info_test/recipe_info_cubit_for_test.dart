import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';

class RecipeInfoCubitForTests extends Cubit<RecipeInfoState>
    implements BaseRecipeInfoCubit {
  RecipeInfoCubitForTests({required Recipe recipe})
        : super(
          RecipeInfoState(status: RecipeInfoStatus.success, recipe: recipe));

  @override
  Future<void> changeFavouriteStatus(
      {required Recipe recipe, required User user}) async {
    Recipe changedInfo;
    try {
      bool newValue = !state.recipe.favouriteStatus.isFavourite;
      int likesNumber = state.recipe.likesNumber;
      if (newValue) {
        changedInfo = state.recipe.copyWith(
            favouriteStatus: FavouriteStatus(
                isFavourite: newValue, favouriteId: 1),
            likesNumber: ++likesNumber);
      } else {
        changedInfo = state.recipe.copyWith(
            favouriteStatus: FavouriteStatus(isFavourite: newValue),
            likesNumber: --likesNumber);
      }
    } catch (e) {
      emit(state.copyWith(
          status: RecipeInfoStatus.error,
          message: ErrorMessages.changeFavouriteStatus));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
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
  }

  @override
  List<Comment> get comments => state.recipe.comments;

  @override
  bool get isFavourite => state.recipe.favouriteStatus.isFavourite;

  @override
  Recipe get recipe => state.recipe;

  @override
  List<UserRecipePhoto> get userPhotos => state.recipe.userPhotos;

  @override
  Future<void> saveComment({required User user,
    required Recipe recipe,
    required String text,
    required Uint8List? photo}) async {
    Recipe changedInfo;
    emit(state.copyWith(status: RecipeInfoStatus.commentProgress));
    final datetime = DateTime.now().toString();
    try {

      final appComment = Comment(
        id: 1,
        text: text,
        photo: photo,
        datetime: DateFormat('dd.MM.yyyy').format(DateTime.parse(datetime)),
        user: user,
      );
      List<Comment> commentList = [...comments];
      commentList.add(appComment);
      changedInfo = state.recipe
          .copyWith(comments: commentList, photoToSendComment: null);
    } catch (e) {
      emit(state.copyWith(
          status: RecipeInfoStatus.error, message: ErrorMessages.sendComment));
      return;
    }
    emit(state.copyWith(recipe: changedInfo));
  }
}