import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_service.dart';
import 'package:receipts/common/constants/app_colors.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    return Stack(children: [
      SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview((cameraCubit.cameraService as CameraService).controller!)),
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
                    cameraCubit.viewPhoto();
                  },
                ),
              ),
              const Spacer(),
              Flexible(
                child: ElevatedButton(
                  child: const Icon(Icons.search, color: Colors.grey),
                  onPressed: () async {
                    cameraCubit
                        .startRealtimeDetection(MediaQuery.sizeOf(context));
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
