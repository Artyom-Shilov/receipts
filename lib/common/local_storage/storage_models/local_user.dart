import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'local_user.freezed.dart';
part 'local_user.g.dart';

@freezed
class LocalUser with _$LocalUser {
  @HiveType(typeId: 7, adapterName: 'LocalUserAdapter')
  const factory LocalUser(
  {
    @HiveField(0) required String login,
    @HiveField(1) required String avatar,
    @HiveField(2) required String id,
  }) = _LocalUser;
}