import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';


abstract interface class BaseRecipeInfoCubit extends Cubit<RecipeInfoState> {
  BaseRecipeInfoCubit(super.initialState);

  Future<void> saveComment(Comment comment);
  Future<void> changeFavouriteStatus();
  Future<void> changeCookingStepStatus(int index);
  Recipe get recipe;
  List<Comment> get comments;
  bool get isFavourite;
  List<UserRecipePhoto> get userPhotos;
}
