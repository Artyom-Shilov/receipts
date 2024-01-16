import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/recipe.dart';

part 'recipe_photo_view_state.freezed.dart';

enum RecipePhotoViewStatus {
  viewing,
  viewingWithDetections,
  choosingCommentPhoto
}

@freezed
class RecipePhotoViewState with _$RecipePhotoViewState {
  const factory RecipePhotoViewState(
  {required Recipe recipe,
   required RecipePhotoViewStatus status
  }) = _RecipePhotoViewState;
}
