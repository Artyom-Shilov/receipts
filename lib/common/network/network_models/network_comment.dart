import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_comment.freezed.dart';

part 'network_comment.g.dart';

@freezed
class NetworkComment with _$NetworkComment {
  const factory NetworkComment(
      {required int id,
      required String text,
      required String photo,
      required String datetime,
      required LinkedToCommentUser user,
      required LinkedToCommentRecipe recipe}) = _NetworkComment;

  factory NetworkComment.fromJson(Map<String, dynamic> json) =>
      _$NetworkCommentFromJson(json);
}

@freezed
class LinkedToCommentUser with _$LinkedToCommentUser {
  const factory LinkedToCommentUser({required int id}) = _LinkedToCommentUser;

  factory LinkedToCommentUser.fromJson(Map<String, dynamic> json) =>
      _$LinkedToCommentUserFromJson(json);
}

@freezed
class LinkedToCommentRecipe with _$LinkedToCommentRecipe {
  const factory LinkedToCommentRecipe({required int id}) =
      _LinkedToCommentRecipe;

  factory LinkedToCommentRecipe.fromJson(Map<String, dynamic> json) =>
      _$LinkedToCommentRecipeFromJson(json);
}
