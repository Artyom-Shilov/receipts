import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/ble_scan/controllers/base_ble_cubit.dart';
import 'package:receipts/ble_scan/controllers/ble_state.dart';
import 'package:receipts/ble_scan/services/base_ble_service.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/app_ble_device.dart';

class BleCubit extends Cubit<BleState> implements BaseBleCubit {
  BleCubit(BaseBleService bleService)
      : _bleService = bleService,
        super(const BleState(scanStatus: ScanStatus.init));

  final BaseBleService _bleService;

  @override
  Future<void> scanBleDevices() async {
    try {
    if (!await _bleService.checkBluetoothAvailability()) {
      emit(state.copyWith(scanStatus: ScanStatus.bluetoothDisabled));
      return;
    }
      await _bleService.askForPermissions();
      if (!await _bleService.checkPermissions()) {
        emit(state.copyWith(scanStatus: ScanStatus.permissionsDisabled));
        return;
      }
      await _bleService.startScanning();
      emit(state.copyWith(scanStatus: ScanStatus.scanning));
      await Future.delayed(const Duration(seconds: 3));
      await _bleService.stopScanning();
      emit(state.copyWith(
          devices: await _bleService.getBleDevices(),
          scanStatus: ScanStatus.done));
    } catch (e) {
      emit(state.copyWith(
          scanStatus: ScanStatus.error,
          message: ErrorMessages.bleScanningError));
      return;
    }
  }

  @override
  List<AppBleDevice> get bleDevices => state.devices ?? [];
}