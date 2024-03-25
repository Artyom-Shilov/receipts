import 'package:bloc/bloc.dart';
import 'package:receipts/ble_scan/controllers/ble_state.dart';
import 'package:receipts/common/models/app_ble_device.dart';

abstract interface class BaseBleCubit extends Cubit<BleState> {
  BaseBleCubit(super.initialState);
  Future<void> scanBleDevices();
  List<AppBleDevice> get bleDevices;
}