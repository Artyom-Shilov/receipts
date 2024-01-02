import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/storage_models/local_user.dart';

part 'local_comment.freezed.dart';
part 'local_comment.g.dart';

@freezed
class LocalComment with _$LocalComment {
  @HiveType(typeId: 4, adapterName: 'LocalCommentAdapter')
  const factory LocalComment(
      { @HiveField(0) required String text,
        @HiveField(1) required String photo,
        @HiveField(2) required String datetime,
        @HiveField(3) required LocalUser user
        }
      ) = _LocalComment;
}
