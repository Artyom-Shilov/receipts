import 'package:receipts/ble_scan/services/base_ble_service.dart';
import 'package:receipts/common/models/app_ble_device.dart';
import 'package:ble_info/ble_info.dart';

class BleService implements BaseBleService {
  @override
  Future<void> askForPermissions() async {
    await BleApi.instance.askForScanPermissions();
  }

  @override
  Future<bool> checkPermissions() async {
   return await BleApi.instance.checkScanPermissions();
  }

  @override
  Future<List<AppBleDevice>> getBleDevices() async {
    final foundDevices = await BleApi.instance.getNearestBleDevices();
    return foundDevices
        .where((element) => element != null && element.deviceName != '')
        .map((e) => AppBleDevice(name: e!.deviceName, address: e.mac))
        .toList();
  }

  @override
  Future<void> startScanning() async {
    await BleApi.instance.startScanning();
  }

  @override
  Future<void> stopScanning() async {
    await BleApi.instance.stopScanning();
  }

  @override
  Future<bool> checkBluetoothAvailability() async {
    return await BleApi.instance.isBluetoothEnable();
  }

}