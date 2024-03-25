import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

import 'recipe_info_state.dart';

class RecipeInfoCubit extends Cubit<RecipeInfoState>
    implements BaseRecipeInfoCubit {
  RecipeInfoCubit(
      {required BaseRecipeRepository repository,
      required BaseNetworkRecipeClient networkClient,
      required Recipe recipe})
      : _repository = repository,
        _networkClient = networkClient,
        super(RecipeInfoState(status: RecipeInfoStatus.success, recipe: recipe)) {
    _recipeSubscription = _repository.recipesStream.listen((event) {
      if (event.firstWhere((element) => element.id == state.recipe.id) !=
          state.recipe) {
        emit(state.copyWith(
            recipe:
                event.firstWhere((element) => element.id == state.recipe.id),
            status: RecipeInfoStatus.success));
      }
    });
  }

  final BaseRecipeRepository _repository;
  final BaseNetworkRecipeClient _networkClient;
  StreamSubscription<List<Recipe>>? _recipeSubscription;

  @override
  Future<void> changeFavouriteStatus(
      {required Recipe recipe, required User user}) async {
    Recipe changedInfo;
    try {
      bool newValue = !state.recipe.favouriteStatus.isFavourite;
      int likesNumber = state.recipe.likesNumber;
      if (newValue) {
        final favouriteId =
            await _networkClient.markAsFavourite(recipe.id, user.id);
        changedInfo = state.recipe.copyWith(
            favouriteStatus: FavouriteStatus(
                isFavourite: newValue, favouriteId: favouriteId),
            likesNumber: ++likesNumber);
      } else {
        await _networkClient
            .unmarkFavourite(recipe.favouriteStatus.favouriteId!);
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
    await _repository.saveRecipeInfo(changedInfo);
  }

  @override
  Future<void> saveComment(
      {required User user,
      required Recipe recipe,
      required String text,
      required Uint8List? photo}) async {
    Recipe changedInfo;
    emit(state.copyWith(status: RecipeInfoStatus.commentProgress));
    final image = photo == null
        ? ''
        : const Base64Encoder().convert(
            await FlutterImageCompress.compressWithList(photo, quality: 75));
    final datetime = DateTime.now().toString();
    try {
      final commentId = await _networkClient.sendComment(
          text: text,
          userId: user.id,
          datetime: datetime,
          recipeId: recipe.id,
          photo: image);
      final appComment = Comment(
        id: commentId,
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
    await _repository.saveRecipeInfo(changedInfo);
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
  Future<void> close() {
    _recipeSubscription?.cancel();
    return super.close();
  }
}
