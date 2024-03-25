import 'package:receipts/common/models/app_ble_device.dart';

abstract interface class BaseBleService {
  Future<bool> checkPermissions();
  Future<bool> checkBluetoothAvailability();
  Future<void> askForPermissions();
  Future<void> startScanning();
  Future<void> stopScanning();
  Future<List<AppBleDevice>> getBleDevices();
}