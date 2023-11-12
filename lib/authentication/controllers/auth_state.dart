import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/user.dart';

part 'auth_state.freezed.dart';

enum AuthStatus {
  loggedIn,
  loggedOut,
  inProgress,
  error
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required AuthStatus status,
    User? user,
  }) = _AuthState;
}