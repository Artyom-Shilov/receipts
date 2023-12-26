import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:receipts/common/models/detection.dart';
import 'package:receipts/common/models/recipe.dart';

part 'camera_state.freezed.dart';

enum CameraStatus {
  init,
  loading,
  ready,
  viewing,
  viewingDetections,
  streaming,
  error,
}

@freezed
class CameraState with _$CameraState {
  factory CameraState(
  {
    required CameraStatus status,
    required Recipe recipe,
    CameraController? cameraController,
    @Default(0) double imageWidth,
    @Default(0) double imageHeight,
    @Default(0) double cameraHeight,
    @Default(0) double cameraWidth,
    Uint8List? viewingPhoto,
    @Default([])List<Detection> detections,
    @Default('') String message,
  }) = _CameraState;
}
