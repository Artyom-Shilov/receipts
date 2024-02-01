import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/ble_scan/controllers/base_ble_cubit.dart';
import 'package:receipts/ble_scan/controllers/ble_state.dart';
import 'package:receipts/ble_scan/widgets/ble_device_list.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/ble_scan/widgets/ble_message.dart';

class BleScanPart extends StatelessWidget {
  const BleScanPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bleCubit = BlocProvider.of<BaseBleCubit>(context);
    return BlocBuilder<BaseBleCubit, BleState>(
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text(BleScanningTexts.startScan,
                    style: TextStyle(color: AppColors.accent, fontSize: 14)),
                onPressed: () async {
                  await bleCubit.scanBleDevices();
                },
              ),
              const SizedBox(width: 10),
              if (state.scanStatus == ScanStatus.scanning)
                const SizedBox(height: 15, width: 15,
                    child: CircularProgressIndicator())
            ],
          ),
          if (state.scanStatus == ScanStatus.bluetoothDisabled)
            const BleMessage(text: BleScanningTexts.bluetoothDisabled),
          if (state.scanStatus == ScanStatus.permissionsDisabled)
            const BleMessage(text: BleScanningTexts.noPermissions),
          if (state.scanStatus == ScanStatus.error)
            BleMessage(text: state.message),
          if (state.scanStatus == ScanStatus.done)
            const Flexible(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.horizontal1),
                child: BleDeviceList(),
              ))
            ],
          );
        }
    );
  }
}
