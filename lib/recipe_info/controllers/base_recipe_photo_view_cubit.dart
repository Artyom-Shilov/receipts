import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

abstract interface class BaseRecipePhotoViewCubit extends Cubit<RecipePhotoViewState> {
  BaseRecipePhotoViewCubit(super.initialState);

  void viewPhoto();
  void viewPhotoWithDetections();
  Future<void> chooseCommentPhoto(Uint8List photo);
  Recipe get recipe;
}