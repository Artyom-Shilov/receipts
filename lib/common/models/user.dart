import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User(
  {
    required String id,
    required String login,
    @Default('') String password,
    @Default('') String token,
    required String avatar,
}) = _User;
}