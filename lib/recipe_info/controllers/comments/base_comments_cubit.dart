import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';

import 'comments_state.dart';

abstract interface class BaseCommentsCubit extends Cubit<CommentsState> {
  BaseCommentsCubit(super.initialState);

  void saveComment({required Comment comment, required Recipe recipe});
  Future<void> loadComments(Recipe? recipe);
}