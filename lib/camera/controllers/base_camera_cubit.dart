import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipts/camera/controllers/base_camera_service.dart';
import 'package:receipts/camera/controllers/camera_state.dart';

abstract interface class BaseCameraCubit extends Cubit<CameraState> {
  BaseCameraCubit(super.initialState);
  Future<void> startRealtimeDetection(Size screenSize);
  Future<void> stopImageStream();
  Future<void> stopRealtimeDetection();
  Future<void> initCamera();
  Future<void> disposeCamera();
  Future<void> takePhoto();
  Future<void> findDetectionsOnPhoto(XFile photo, Size screenSize);
  Future<void> takePhotoAndFindDetections(Size screenSize);
  void declinePhoto();
  void viewPhoto();
  void viewPhotoWithDetections();
  Future<void> savePhoto();
  BaseCameraService get cameraService;
}