import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/app_ble_device.dart';

part 'ble_state.freezed.dart';

enum ScanStatus {
  init,
  bluetoothDisabled,
  permissionsDisabled,
  scanning,
  done,
  error
}

@freezed
class BleState with _$BleState {
  const factory BleState(
  {required ScanStatus scanStatus,
   List<AppBleDevice>? devices,
   @Default('') String message
  }) = _BleState;
}