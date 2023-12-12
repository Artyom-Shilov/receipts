import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:camera/src/camera_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';

class CameraCubit extends Cubit<CameraState> implements BaseCameraCubit {
  CameraCubit({required BaseRecipeRepository repository, required Recipe recipe})
      :  _repository = repository,
        super(CameraState(status: CameraStatus.init, recipe:  recipe));

  final BaseRecipeRepository _repository;

  Future<List<dynamic>?> _detectObjectOnFrame(CameraImage frame) async {
    return await Tflite.detectObjectOnFrame(
      bytesList: frame.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: "SSDMobileNet",
      imageHeight: frame.height,
      imageWidth: frame.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    );
  }

  @override
 Future<void> startDetectObjectsInFrameStream() async {
    bool isDetecting = false;
    emit(state.copyWith(status: CameraStatus.streaming));
    state.cameraController!.startImageStream((CameraImage img) {
       if (!isDetecting) {
        isDetecting = true;
        int startTime = new DateTime.now().millisecondsSinceEpoch;
          Tflite.detectObjectOnFrame(
            bytesList: img.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            model: "SSDMobileNet",
            imageHeight: img.height,
            imageWidth: img.width,
            imageMean: 127.5,
            imageStd: 127.5,
            numResultsPerClass: 1,
            threshold: 0.4,
          ).then((recognitions) {
            int endTime = new DateTime.now().millisecondsSinceEpoch;
            print("Detection took ${endTime - startTime}");
            emit(state.copyWith(imageWidth: img.width, imageHeight: img.height,  recognitions: recognitions));
            isDetecting = false;
          });
        }
  });
    /*if (state.cameraController != null) {
      state.cameraController!.startImageStream((CameraImage image) async {
        final recognitions = await _detectObjectOnFrame(image);
        emit(state.copyWith(status: DetectionStatus.streaming,
            image: image,
            recognitions: recognitions));
      });
    }*/
  }

  @override
  Future<void> initCameraDetection() async {
    emit(state.copyWith(status: CameraStatus.loading));
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
      await Tflite.loadModel( model: "assets/detection/ssd_mobilenet.tflite",
          labels: "assets/detection/ssd_mobilenet.txt");
    } catch (e) {
      emit(state.copyWith(status: CameraStatus.error));
      return;
    }
    CameraController controller =
        CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    emit(state.copyWith(status: CameraStatus.ready, cameraController: controller));
  }

  @override
  Future<void> stopDetectObjectsInFrameStream() async {
    emit(state.copyWith(status: CameraStatus.ready));
    await state.cameraController!.stopImageStream();
  }

  @override
  Future<void> detectObjectsOnImage(XFile picture) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    final r = await picture.readAsBytes();
    final rr = await decodeImageFromList(r);

    Tflite.detectObjectOnImage(
      path: picture.path,
      model: "SSDMobileNet",
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    ).then((recognitions) {
      int endTime = new DateTime.now().millisecondsSinceEpoch;
      print("Detection took ${endTime - startTime}");
      //emit(state.copyWith(image: picture., recognitions: recognitions));
    });
  }

    @override
    Future<void> saveUserRecipePhoto(Future<XFile> photoFuture) async {
      final photo = await photoFuture;
      final photoBytes = await photo.readAsBytes();
      Recipe changedInfo;
      try {
        List<UserRecipePhoto> userPhotoList = [...state.recipe.userPhotos];
        userPhotoList.add(UserRecipePhoto(photoBites: photoBytes));
        changedInfo = state.recipe.copyWith(userPhotos: userPhotoList);
      } catch (e) {
        emit(state.copyWith(
            status: CameraStatus.error));
        return;
      }
      emit(state.copyWith(recipe: changedInfo));
      await _repository.saveRecipeInfo(changedInfo);
    }
}