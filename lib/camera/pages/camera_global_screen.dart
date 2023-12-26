import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/pages/camera_realtime_detection_page.dart';
import 'package:receipts/camera/pages/camera_page.dart';
import 'package:receipts/camera/pages/photo_view_page.dart';

class CameraGlobalScreen extends HookWidget {
  const CameraGlobalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    log(cameraCubit.state.status.name, time: DateTime.now());
    useEffect(() {
      cameraCubit.initCamera();
      return () => cameraCubit.disposeCamera();
    });
    return Scaffold(
      body: Stack(children: [
        BlocBuilder<BaseCameraCubit, CameraState>(
            buildWhen: (prev, next) => prev.status != next.status,
            builder: (context, state) {
              return switch (state.status) {
                CameraStatus.init ||
                CameraStatus.loading =>
                  const Center(child: CircularProgressIndicator()),
                CameraStatus.ready => const CameraPage(),
                CameraStatus.streaming => const CameraRealtimeDetectionPage(),
                CameraStatus.viewing ||
                CameraStatus.viewingDetections =>
                  const PhotoViewPage(),
                CameraStatus.error => Center(child: Text(state.message)),
              };
            }),
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ))
      ]),
    );
  }
}