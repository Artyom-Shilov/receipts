import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_process_state.freezed.dart';

enum ProcessStatus {
  login,
  registration,
}

@freezed
class AuthProcessState with _$AuthProcessState {
  const factory AuthProcessState(
  { @Default(ProcessStatus.login) ProcessStatus process,
    @Default(false) isFormValidationError,}
      ) = _AuthProcessState;
}
