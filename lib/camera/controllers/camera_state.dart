import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:camera/camera.dart';
import 'package:receipts/common/models/recipe.dart';

part 'camera_state.freezed.dart';

enum CameraStatus {
  init,
  loading,
  ready,
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
    @Default(0) int imageWidth,
    @Default(0) int imageHeight,
    List<dynamic>? recognitions,
  }) = _CameraState;

}
