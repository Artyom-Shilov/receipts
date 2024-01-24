import 'package:camera/camera.dart';
import 'package:receipts/camera/controllers/base_camera_service.dart';

class CameraService implements BaseCameraService {

  CameraController? controller;

  @override
  Future<void> disposeCamera() async {
    await controller?.dispose();
  }

  @override
  Future<void> initCamera() async {
    List<CameraDescription> cameras;
    cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    await controller?.initialize();
  }

  @override
  Future<XFile> takePicture() async {
    return controller!.takePicture();
  }

  @override
  Future<void> startImageStream(Function(CameraImage image) onAvailable) async {
    await controller?.startImageStream(onAvailable);
  }

  @override
  Future<void> stopImageStream() async {
    await controller?.stopImageStream();
  }

}