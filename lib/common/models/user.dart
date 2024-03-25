import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User(
  {
    required int id,
    required String login,
    String? password,
    String? token,
    Uint8List? avatar,
}) = _User;
}