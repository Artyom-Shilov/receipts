import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/comment.dart';

part 'comments_state.freezed.dart';

enum CommentsStatus {
  initial,
  loading,
  success,
  error
}

@freezed
class CommentsState with _$CommentsState {

   const factory CommentsState({
     required List<Comment> comments,
     required CommentsStatus status,
   }) = _CommentsState;
}
