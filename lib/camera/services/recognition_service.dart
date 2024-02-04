import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/camera/services/base_recognition_service.dart';
import 'package:receipts/common/constants/recognition_constants.dart';
import 'package:receipts/common/models/detection.dart';

const splitCharacter = '|';

Map<String, dynamic> _formDetection(
    {required dynamic modelResult,
    required double screenHeight,
    required double screenWidth}) {
  final modelX =
      modelResult[RecognitionConstants.rectKey][RecognitionConstants.xKey];
  final modelWidth =
      modelResult[RecognitionConstants.rectKey][RecognitionConstants.wKey];
  final modelY =
      modelResult[RecognitionConstants.rectKey][RecognitionConstants.yKey];
  final modelHeight =
      modelResult[RecognitionConstants.rectKey][RecognitionConstants.hKey];

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
      detectedClass: modelResult[RecognitionConstants.detectedClassKey],
      confidence:
          '${(modelResult[RecognitionConstants.confidenceInClassKey] * 100).toStringAsFixed(0)}%').toJson();
}

class RecognitionService implements BaseRecognitionService {

  final ReceivePort _imageDetectionReceivePort = ReceivePort();
  List<Detection> _lastDetectionsOnImage = [];
  final ReceivePort _frameDetectionReceivePort = ReceivePort();
  List<Detection> _lastDetectionsOnFrame = [];

  late Completer<void> _imageDetectionInitCompleter;
  late Completer<void> _imageDetectionCompleter;
  late Completer<void> _frameDetectionInitCompleter;
  late Completer<void> _frameDetectionCompleter;
  late StreamSubscription? _frameDetectionSubscription;
  late StreamSubscription? _imageDetectionSubscription;
  late SendPort _sendPortToImageDetectionIsolate;
  late SendPort _sendPortToFrameDetectionIsolate;
  late Isolate? _imageDetectionIsolate;
  late Isolate? _frameDetectionIsolate;

  final model = RecognitionConstants.modelName;

  RecognitionService() {
    _imageDetectionSubscription = _imageDetectionReceivePort.listen((message) {
      if (message is SendPort) {
        _sendPortToImageDetectionIsolate = message;
        _imageDetectionInitCompleter.complete();
      }
      if (message is TransferableTypedData) {
        final jsonMessage = String.fromCharCodes(message.materialize().asUint32List());
        final jsonDetections = json.decode(jsonMessage) as List;
        _lastDetectionsOnImage = jsonDetections.map((e) => Detection.fromJson(e)).toList();
        _imageDetectionCompleter.complete();
      }
    });
    _frameDetectionSubscription = _frameDetectionReceivePort.listen((message) {
      if (message is SendPort) {
        _sendPortToFrameDetectionIsolate = message;
        _frameDetectionInitCompleter.complete();
      }
      if (message is List<Detection>) {
      }
    });
  }

  Future<void> _spawnFrameDetectionIsolate() async {
    _frameDetectionIsolate = await Isolate.spawn(
            (port) {
              final isolateReceivePort = ReceivePort();
              port.send(isolateReceivePort.sendPort);
              isolateReceivePort.listen((message) async {

              });
            },
        _frameDetectionReceivePort.sendPort);
  }

  Future<void> _spawnImageDetectionIsolate() async {
    final token = RootIsolateToken.instance!;
    _imageDetectionIsolate = await Isolate.spawn((port) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      final isolateReceivePort = ReceivePort();
      port.send(isolateReceivePort.sendPort);
      isolateReceivePort.listen((message) async {
        if (message is TransferableTypedData) {
          List<dynamic> input = jsonDecode(String.fromCharCodes(message.materialize().asInt32List()));
          final path = input[0] as String;
          final modelName = input[1] as String;
          final height = double.parse(input[2] as String);
          final width = double.parse(input[3] as String);
          List<Map<String, dynamic>> detections = [];
          await Tflite.detectObjectOnImage(
                  model: modelName,
                  path: path,
                  numResultsPerClass: 1,
                  threshold: 0.1,
                  blockSize: 128)
              .then((recognitions) {
            detections = recognitions
                    ?.where((e) =>
                        (e[RecognitionConstants.confidenceInClassKey] * 100) >
                        40)
                    .map((e) => _formDetection(
                        modelResult: e,
                        screenHeight: height,
                        screenWidth: width))
                    .toList() ??
                [];
          });
          final transferableData = TransferableTypedData.fromList(
              [Int32List.fromList(json.encode(detections).codeUnits)]);
          port.send(transferableData);
        }
      });
    }, _imageDetectionReceivePort.sendPort);
  }

  @override
  Future<void> initRecognitionService() async {
    await Tflite.loadModel(
        model: "assets/detection/ssd_mobilenet.tflite",
        labels: "assets/detection/ssd_mobilenet.txt");
    _imageDetectionInitCompleter = Completer.sync();
    _imageDetectionCompleter = Completer.sync();
    await _spawnImageDetectionIsolate();
  }

  @override
  Future<void> disposeRecognitionService() async {
    await Tflite.close();
   _imageDetectionSubscription?.cancel();
   _imageDetectionIsolate?.kill();
  }

  @override
  Future<List<Detection>> findDetectionsOnPhoto(
      XFile photo, Size screenSize) async {
    final data = [
      photo.path,
      model,
      screenSize.height.toString(),
      screenSize.width.toString()
    ];
    final transferableData = TransferableTypedData.fromList(
        [Int32List.fromList(jsonEncode(data).codeUnits)]);
    _sendPortToImageDetectionIsolate.send(transferableData);
    await _imageDetectionCompleter.future;
    _imageDetectionCompleter = Completer.sync();
    return _lastDetectionsOnImage;
  }

  @override
  Future<List<Detection>> findDetectionsOnFrame({required List<Uint8List> frame,
    required Size screenSize,
    required int height,
    required int width}) async {
    List<Detection> detections = [];
    await Tflite.detectObjectOnFrame(
      bytesList: frame,
      model: RecognitionConstants.modelName,
      imageHeight: height,
      imageWidth: width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResultsPerClass: 1,
      threshold: 0.4,
    ).then((recognitions) {
     /* detections = recognitions
          ?.where((e) => (e[RecognitionConstants.confidenceInClassKey] * 100) > 40)
          .map((e) => _formDetection(modelResult: e, screenHeight: screenSize.height, screenWidth: screenSize.width))
          .toList() ?? [];*/
    });
    return detections;
  }
}