import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/widgets/detections_stack.dart';
import 'package:receipts/common/constants/constants.dart';

class CameraRealtimeDetectionPage extends StatelessWidget {
  const CameraRealtimeDetectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    return Stack(children: [
      SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: CameraPreview(cameraCubit.state.cameraController!)
      ),
      SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: BlocBuilder<BaseCameraCubit, CameraState>(
              buildWhen: (prev, next) => prev.detections != next.detections,
              builder: (context, state) {
                return DetectionStack(detections: state.detections);
              })),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ElevatedButton(
                  child: const Icon(
                    Icons.add_a_photo_sharp,
                    color: AppColors.accent,
                  ),
                  onPressed: () async {
                    await cameraCubit
                        .takePhotoAndFindDetections(MediaQuery.sizeOf(context));
                    await cameraCubit.stopRealtimeDetection();
                    await cameraCubit.viewPhoto();
                  },
                ),
              ),
              const Spacer(),
              Flexible(
                child: ElevatedButton(
                  child: const Icon(
                    Icons.search,
                    color: AppColors.accent,
                  ),
                  onPressed: () async {
                    await cameraCubit.stopRealtimeDetection();
                  },
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
