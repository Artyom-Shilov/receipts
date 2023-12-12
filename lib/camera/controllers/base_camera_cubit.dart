import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:receipts/camera/controllers/camera_state.dart';


abstract interface class BaseCameraCubit extends Cubit<CameraState> {
  BaseCameraCubit(super.initialState);
  Future<void> startDetectObjectsInFrameStream();
  Future<void> stopDetectObjectsInFrameStream();
  Future<void> detectObjectsOnImage(XFile picture);
  Future<void> initCameraDetection();
  Future<void> saveUserRecipePhoto(Future<XFile> photoFuture);
}