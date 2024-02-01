import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_ble_device.freezed.dart';

@freezed
class AppBleDevice with _$AppBleDevice {
  const factory AppBleDevice({required String name, required String address}) =
      _AppBleDevice;
}
