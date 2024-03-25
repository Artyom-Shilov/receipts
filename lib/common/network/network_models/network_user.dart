import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_user.freezed.dart';
part 'network_user.g.dart';

@freezed
class NetworkUser with _$NetworkUser {
  const factory NetworkUser(
    String? avatar,
    String? token, {
    required int id,
    required String login,
    required String password,
  }) = _NetworkUser;

  factory NetworkUser.fromJson(Map<String, dynamic> json) =>
      _$NetworkUserFromJson(json);
}
