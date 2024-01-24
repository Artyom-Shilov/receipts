import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/detection.dart';
import 'package:receipts/common/models/recipe.dart';

part 'camera_state.freezed.dart';

enum CameraStatus {
  initializing,
  ready,
  viewing,
  viewingWithDetections,
  streaming,
  closing,
  error,
}

@freezed
class CameraState with _$CameraState {
  factory CameraState(
  {
    required CameraStatus status,
    required Recipe recipe,
    @Default(0) double imageWidth,
    @Default(0) double imageHeight,
    @Default(0) double cameraHeight,
    @Default(0) double cameraWidth,
    Uint8List? viewingPhoto,
    @Default([])List<Detection> detections,
    @Default('') String message,
  }) = _CameraState;
}
