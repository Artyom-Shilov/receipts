import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/services/base_camera_service.dart';
import 'package:receipts/camera/controllers/camera_state.dart';
import 'package:receipts/camera/services/base_detection_service.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';

class CameraCubit extends Cubit<CameraState> implements BaseCameraCubit {
  CameraCubit(
      {required BaseRecipeRepository repository,
      required Recipe recipe,
      required BaseDetectionService detectionService,
      required this.cameraService})
      : _repository = repository,
        _detectionService = detectionService,
        super(CameraState(status: CameraStatus.initializing, recipe: recipe)) {
    errorStreamController.addStream(detectionService.errorStream);
    _detectionServiceErrorSubscription =
        detectionService.errorStream.listen((event) async {
      emit(state.copyWith(
          status: CameraStatus.error, message: ErrorMessages.detectionError));
      await cameraService.disposeCamera();
      await _detectionService.disposeRecognitionService();
    });
  }

  final BaseRecipeRepository _repository;
  final BaseDetectionService _detectionService;
  StreamSubscription? _detectionServiceErrorSubscription;
  final  errorStreamController = StreamController();
  @override
  final BaseCameraService cameraService;

  @override
  Future<void> initCamera() async {
    emit(state.copyWith(status: CameraStatus.initializing));
    try {
      await cameraService.initCamera();
      await _detectionService.initRecognitionService();
    } catch (e) {
      emit(state.copyWith(
          status: CameraStatus.error, message: ErrorMessages.photoProcessInitError));
      return;
    }
    emit(state.copyWith(status: CameraStatus.ready));
  }

  @override
  Future<void> disposeCamera() async {
    if (state.status == CameraStatus.streaming) {
      await cameraService.stopImageStream();
    }
    emit(state.copyWith(status: CameraStatus.initializing));
    await cameraService.disposeCamera();
    await _detectionService.disposeRecognitionService();
  }

  @override
  Future<void> stopRealtimeDetection() async {
    emit(state.copyWith(status: CameraStatus.ready));
    await cameraService.stopImageStream();
  }

  @override
  Future<void> savePhoto() async {
    Recipe changedInfo;
    try {
      UserRecipePhoto photo = UserRecipePhoto(
          index: state.recipe.userPhotos.length + 1,
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
    final photo = await cameraService.takePicture()
        .then((value) => value.readAsBytes());
    emit(state.copyWith(viewingPhoto: photo));
  }

  @override
  Future<void> findDetectionsOnPhoto(XFile photo, Size screenSize) async {
    final detections = await _detectionService.findDetectionsOnPhoto(photo, screenSize);
    emit(state.copyWith(detections: detections));
  }

  @override
  Future<void> takePhotoAndFindDetections(Size screenSize) async {
    final photo = await cameraService.takePicture();
    await findDetectionsOnPhoto(photo, screenSize);
    emit(state.copyWith(viewingPhoto: await photo.readAsBytes()));

  }

  @override
  Future<void> startRealtimeDetection(Size screenSize) async {
    bool isDetecting = false;
    emit(state.copyWith(status: CameraStatus.streaming));
    cameraService.startImageStream(
            (image) async {
              if (!isDetecting) {
                isDetecting = true;
                final detections = await _detectionService.findDetectionsOnFrame(
                    frame: image.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    screenSize: screenSize,
                    height: image.height,
                    width: image.width);
                if (state.status == CameraStatus.streaming) {
                  emit(state.copyWith(
                      imageWidth: image.width.toDouble(),
                      imageHeight: image.height.toDouble(),
                      detections: detections));
                }
                isDetecting = false;
              }
            }
    );
  }

  @override
  void declinePhoto() {
    emit(state.copyWith(
        status: CameraStatus.ready, viewingPhoto: null, detections: []));
  }

  @override
  void viewPhotoWithDetections() {
    emit(state.copyWith(status: CameraStatus.viewingWithDetections));
  }

  @override
   viewPhoto() {
    emit(state.copyWith(status: CameraStatus.viewing));
  }


  @override
  Future<void> close() async {
    await _detectionServiceErrorSubscription?.cancel();
    await cameraService.disposeCamera();
    await _detectionService.disposeRecognitionService();
    return super.close();
  }
}
