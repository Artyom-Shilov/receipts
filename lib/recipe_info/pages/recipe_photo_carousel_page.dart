import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/widgets/detections_stack.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/util/util_logic.dart';
import 'package:receipts/common/widgets/back_navigation_arrow.dart';

class RecipePhotoCarouselPage extends HookWidget {
  const RecipePhotoCarouselPage(
      {Key? key, required this.photos, required this.initIndex})
      : super(key: key);

  final List<UserRecipePhoto> photos;
  final int initIndex;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      UtilLogic.fixPortraitUpOrientation();
      return () {
      UtilLogic.unfixOrientation();
      };
    });
    return Scaffold(
      body: Stack(children: [
        CarouselSlider(
          options: CarouselOptions(
            initialPage: initIndex,
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
          ),
          items: photos.map((item) {
            final cameraCubit = BlocProvider.of<BaseCameraCubit>(context);
            cameraCubit.viewPhoto();
            return BlocBuilder<BaseCameraCubit, CameraState>(
              builder: (context, state) {
                return Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: MemoryImage(item.photoBites),
                            fit: BoxFit.fill)),
                  ),
                  if (item.detections.isNotEmpty &&
                      state.status == CameraStatus.viewingWithDetections)
                    DetectionStack(
                      detections: item.detections,
                    ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: ElevatedButton(
                              onPressed: () async {
                                if (state.status == CameraStatus.viewing) {
                                  if (item.detections.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: const Text(DetectionTexts
                                                .couldNotReliableFindDetections),
                                            action: SnackBarAction(
                                              label:
                                                  DetectionTexts.undoSnackBar,
                                              onPressed: () {},
                                            )));
                                  }
                                  await cameraCubit.viewPhotoWithDetections();
                                } else {
                                  await cameraCubit.viewPhoto();
                                }
                              },
                              child: Icon(
                                Icons.search,
                                color: state.status == CameraStatus.viewing
                                    ? Colors.grey
                                    : AppColors.accent,
                              )))),
                  const BackNavigationArrow()
                ]);
              },
            );
          }).toList(),
        ),
      ]),
    );
  }
}
