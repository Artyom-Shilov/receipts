import 'package:camera/camera.dart';

abstract interface class BaseCameraService {

  Future<void> initCamera();
  Future<XFile> takePicture();
  Future<void> startImageStream(Function(CameraImage image) onAvailable);
  Future<void> stopImageStream();
  Future<void> disposeCamera();
}