import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/widgets/detections_stack.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';

class PhotoViewPage extends StatelessWidget {
  const PhotoViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
    return BlocBuilder<BaseCameraCubit, CameraState>(
        builder: (context, state) {
      return Stack(children: [
        Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: MemoryImage(cameraCubit.state.viewingPhoto!),
                    fit: BoxFit.cover))),
        if (state.detections.isNotEmpty &&
            state.status == CameraStatus.viewingWithDetections)
          DetectionStack(
            detections: state.detections,
          ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    cameraCubit.declinePhoto();
                  },
                  child: const Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    cameraCubit.savePhoto();
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.done,
                    color: AppColors.accent,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (state.status == CameraStatus.viewing) {
                        if (state.detections.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(DetectionTexts
                                  .couldNotReliableFindDetections),
                              action: SnackBarAction(
                                label: DetectionTexts.undoSnackBar,
                                onPressed: () {},
                              )));
                        }
                        cameraCubit.viewPhotoWithDetections();
                      } else {
                        cameraCubit.viewPhoto();
                      }
                    },
                    child: Icon(
                      Icons.search,
                      color: state.status == CameraStatus.viewing
                          ? Colors.grey
                          : AppColors.accent,
                    ))
              ],
            ),
          ),
        )
      ]);
    });
  }
}
