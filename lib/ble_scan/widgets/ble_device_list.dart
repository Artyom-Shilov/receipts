import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/ble_scan/controllers/base_ble_cubit.dart';
import 'package:receipts/common/constants/constants.dart';

class BleDeviceList extends StatelessWidget {
  const BleDeviceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bleCubit = BlocProvider.of<BaseBleCubit>(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: bleCubit.bleDevices.length,
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemBuilder: (context, index) => Text(
        bleCubit.bleDevices[index].name,
        maxLines: 1,
        style: const TextStyle(
            color: AppColors.main,
            fontSize: 14,
            overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
