import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/user.dart';

part 'comment.freezed.dart';

@freezed
class Comment with _$Comment {
  const factory Comment(
      {
        required String text,
        Uint8List? photo,
        required String datetime,
        required User user,
        required int id
        }
      ) = _Comment;
}
