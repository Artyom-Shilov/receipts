import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/user.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment(
      { required String text,
        required String photo,
        required String datetime,
        required User user
        }
      ) = _Comment;
}
