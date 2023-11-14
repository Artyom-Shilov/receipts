import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/comments/base_comments_cubit.dart';
import 'package:receipts/recipe_info/services/base_comments_service.dart';

import 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> implements BaseCommentsCubit {
  CommentsCubit(this._service)
      : super(
            const CommentsState(comments: [], status: CommentsStatus.initial));
  final BaseCommentsService _service;

  @override
  Future<void> loadComments(Recipe? recipe) async {
    if (recipe == null) {
      emit(state.copyWith(status: CommentsStatus.error));
      return;
    } else {
      emit(state.copyWith(status: CommentsStatus.loading));
      List<Comment> comments;
      try {
        comments = await _service.getComments(recipe);
      } catch (e) {
        emit(state.copyWith(status: CommentsStatus.error));
        return;
      }
      emit(state.copyWith(status: CommentsStatus.success, comments: comments));
    }
  }

  @override
  void saveComment({required Comment comment, required Recipe recipe}) async {
    if (state.status == CommentsStatus.success) {
      await _service.saveComment(comment: comment,recipe: recipe);
      emit(state.copyWith(comments: List.of(state.comments)..add(comment)));
    }
  }
}