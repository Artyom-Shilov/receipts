import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/detection.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';

class CameraCubit extends Cubit<CameraState> implements BaseCameraCubit {
  CameraCubit(
      {required BaseRecipeRepository repository, required Recipe recipe})
      : _repository = repository,
        super(CameraState(status: CameraStatus.init, recipe: recipe));

  final BaseRecipeRepository _repository;

  @override
  Future<void> initCamera() async {
    emit(state.copyWith(status: CameraStatus.loading));
    List<CameraDescription> cameras;
    try {
      cameras = await availableCameras();
      await Tflite.loadModel(
          model: "assets/detection/ssd_mobilenet.tflite",
          labels: "assets/detection/ssd_mobilenet.txt");
    } catch (e) {
      emit(state.copyWith(
          status: CameraStatus.error, message: ErrorMessages.cameraInitError));
      return;
    }
    CameraController controller =
        CameraController(cameras[0], ResolutionPreset.high);
    await controller.initialize();
    emit(state.copyWith(
        status: CameraStatus.ready, cameraController: controller));
  }

  @override
  Future<void> disposeCamera() async {
    if (state.status == CameraStatus.streaming) {
      state.cameraController?.stopImageStream();
    }
    emit(state.copyWith(status: CameraStatus.loading));
    await Tflite.close();
    await state.cameraController?.dispose();
  }

  @override
  Future<void> stopRealtimeDetection() async {
    emit(state.copyWith(status: CameraStatus.ready));
    await state.cameraController!.stopImageStream();
  }

  @override
  Future<void> savePhoto() async {
    Recipe changedInfo;
    try {
      UserRecipePhoto photo = UserRecipePhoto(
          photoBites: state.viewingPhoto!, detections: state.detections);
      List<UserRecipePhoto> userPhotoList = [...state.recipe.userPhotos];
      userPhotoList.add(photo);
      changedInfo = state.recipe.copyWith(userPhotos: userPhotoList);
    } catch (e) {
      emit(state.copyWith(status: CameraStatus.error));
      return;
    }
    await _repository.saveRecipeInfo(changedInfo);
    emit(state.copyWith(recipe: changedInfo));
  }

  @override
  Future<void> takePhoto() async {
    final photo = await state.cameraController!
        .takePicture()
        .then((value) => value.readAsBytes());
    emit(state.copyWith(viewingPhoto: photo));
  }

  @override
  Future<void> findDetectionsOnPhoto(XFile photo, Size screenSize) async {
    await Tflite.detectObjectOnImage(
            model: "SSDMobileNet",
            path: photo.path,
            numResultsPerClass: 1,
            threshold: 0.1,
            blockSize: 128)
        .then((recognitions) {
      final detections = recognitions
              ?.where((e) => (e["confidenceInClass"] * 100) > 40)
              .map((e) => _formDetection(e, screenSize))
              .toList() ?? [];
      emit(state.copyWith(detections: detections));
    });
  }

  @override
  Future<void> takePhotoAndFindDetections(Size screenSize) async {
    final photo = await state.cameraController!.takePicture();
    await findDetectionsOnPhoto(photo, screenSize);
    emit(state.copyWith(viewingPhoto: await photo.readAsBytes()));
  }

  @override
  Future<void> startRealtimeDetection(Size screenSize) async {
    bool isDetecting = false;
    emit(state.copyWith(status: CameraStatus.streaming));
    state.cameraController!.startImageStream((CameraImage img) {
      if (!isDetecting) {
        isDetecting = true;
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
          final detections = recognitions
                  ?.where((e) => (e["confidenceInClass"] * 100) > 40)
                  .map((e) => _formDetection(e, screenSize))
                  .toList() ?? [];
          if (state.status == CameraStatus.streaming) {
            emit(state.copyWith(
                imageWidth: img.width.toDouble(),
                imageHeight: img.height.toDouble(),
                detections: detections));
          }
          isDetecting = false;
        });
      }
    });
  }

  Detection _formDetection(dynamic modelResult, Size screenSize) {
    final modelX = modelResult["rect"]["x"];
    final modelWidth = modelResult["rect"]["w"];
    final modelY = modelResult["rect"]["y"];
    final modelHeight = modelResult["rect"]["h"];

    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    double widthScale, heightScale, x, y, width, height;

    widthScale = screenWidth;
    heightScale = screenHeight;
    x = modelX * widthScale;
    width = modelWidth * widthScale;
    y = modelY * heightScale;
    height = modelHeight * heightScale;

    return Detection(
        x: x,
        y: y,
        width: width,
        height: height,
        detectedClass: modelResult['detectedClass'],
        confidence:
            '${(modelResult["confidenceInClass"] * 100).toStringAsFixed(0)}%');
  }

  @override
  Future<void> declinePhoto() async {
    emit(state.copyWith(
        status: CameraStatus.ready, viewingPhoto: null, detections: []));
  }

  @override
  Future<void> viewPhotoWithDetections() async {
    emit(state.copyWith(status: CameraStatus.viewingWithDetections));
  }

  @override
  Future<void> viewPhoto() async {
    emit(state.copyWith(status: CameraStatus.viewing));
  }
}
