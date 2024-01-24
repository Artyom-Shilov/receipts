import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/pages/camera_realtime_detection_page.dart';
import 'package:receipts/camera/pages/camera_page.dart';
import 'package:receipts/camera/pages/photo_view_page.dart';
import 'package:receipts/common/util/util_logic.dart';
import 'package:receipts/common/widgets/back_navigation_arrow.dart';

class CameraGlobalScreen extends HookWidget {
  const CameraGlobalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    log(cameraCubit.state.status.name, time: DateTime.now());
    useEffect(() {
      cameraCubit.initCamera();
      UtilLogic.fixPortraitUpOrientation();
      return () {
        cameraCubit.disposeCamera();
        UtilLogic.unfixOrientation();
      };
    });
    return Scaffold(
      body: Stack(children: [
        BlocBuilder<BaseCameraCubit, CameraState>(
            buildWhen: (prev, next) => prev.status != next.status,
            builder: (context, state) {
              return switch (state.status) {
                CameraStatus.initializing || CameraStatus.closing =>
                  const Center(child: CircularProgressIndicator()),
                CameraStatus.ready => const CameraPage(),
                CameraStatus.streaming => const CameraRealtimeDetectionPage(),
                CameraStatus.viewing ||
                CameraStatus.viewingWithDetections =>
                  const PhotoViewPage(),
                CameraStatus.error => Center(child: Text(state.message)),
              };
            }),
        const BackNavigationArrow()
      ]),
    );
  }
}