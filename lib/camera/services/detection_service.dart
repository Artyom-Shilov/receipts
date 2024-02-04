import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:receipts/camera/services/base_detection_service.dart';
import 'package:receipts/common/constants/recognition_constants.dart';
import 'package:receipts/common/models/detection.dart';

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
              '${(modelResult[RecognitionConstants.confidenceInClassKey] * 100).toStringAsFixed(0)}%')
      .toJson();
}

class DetectionService implements BaseDetectionService {
  final ReceivePort _imageDetectionReceivePort = ReceivePort();
  List<Detection> _lastDetectionsOnImage = [];
  final ReceivePort _frameDetectionReceivePort = ReceivePort();
  List<Detection> _lastDetectionsOnFrame = [];
  final ReceivePort _errorReceivePort = ReceivePort();

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

  DetectionService() {
    _imageDetectionSubscription = _imageDetectionReceivePort.listen((message) {
      if (message is SendPort) {
        _sendPortToImageDetectionIsolate = message;
        _imageDetectionInitCompleter.complete();
      }
      if (message is TransferableTypedData) {
        final jsonMessage =
            String.fromCharCodes(message.materialize().asUint32List());
        final jsonDetections = json.decode(jsonMessage) as List;
        _lastDetectionsOnImage =
            jsonDetections.map((e) => Detection.fromJson(e)).toList();
        _imageDetectionCompleter.complete();
      }
    });
    _frameDetectionSubscription = _frameDetectionReceivePort.listen((message) {
      if (message is SendPort) {
        _sendPortToFrameDetectionIsolate = message;
        _frameDetectionInitCompleter.complete();
      }
      if (message is TransferableTypedData) {
        final jsonMessage =
            String.fromCharCodes(message.materialize().asUint32List());
        final jsonDetections = json.decode(jsonMessage) as List;
        _lastDetectionsOnFrame =
            jsonDetections.map((e) => Detection.fromJson(e)).toList();
        _frameDetectionCompleter.complete();
      }
    }
    );
  }

  Future<void> _spawnDetectionOnFrameIsolate() async {
    final token = RootIsolateToken.instance!;
    _frameDetectionIsolate = await Isolate.spawn((port) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      final isolateReceivePort = ReceivePort();
      port.send(isolateReceivePort.sendPort);
      List<Uint8List>? frame;
      isolateReceivePort.listen((message) async {
        if (message is List<Uint8List>) {
          frame = message;
        }
        if (message is TransferableTypedData) {
          if (frame != null) {
            final messageList = jsonDecode(
                    String.fromCharCodes(message.materialize().asUint32List()))
                as List;
            final modelName = messageList[0] as String;
            final screenHeight = messageList[1] as double;
            final screenWidth = messageList[2] as double;
            final imageHeight = messageList[3] as int;
            final imageWidth = messageList[5] as int;
            List<Map<String, dynamic>> detections = [];
            await Tflite.detectObjectOnFrame(
              bytesList: frame!,
              model: modelName,
              imageHeight: imageHeight,
              imageWidth: imageWidth,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 1,
              threshold: 0.4,
            ).then((recognitions) {
              detections = recognitions
                      ?.where((e) =>
                          (e[RecognitionConstants.confidenceInClassKey] * 100) > 40)
                      .map((e) => _formDetection(
                          modelResult: e,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth))
                      .toList() ?? [];
            });
            final transferableData = TransferableTypedData.fromList(
                [Int32List.fromList(json.encode(detections).codeUnits)]);
            port.send(transferableData);
          }
        }
      });
    },
        _frameDetectionReceivePort.sendPort,
        onError: _errorReceivePort.sendPort,
    );
  }

  Future<void> _spawnDetectionOnImageIsolate() async {
    final token = RootIsolateToken.instance!;
    _imageDetectionIsolate = await Isolate.spawn((port) {
      BackgroundIsolateBinaryMessenger.ensureInitialized(token);
      final isolateReceivePort = ReceivePort();
      port.send(isolateReceivePort.sendPort);
      isolateReceivePort.listen((message) async {
        if (message is TransferableTypedData) {
          List<dynamic> input = jsonDecode(
              String.fromCharCodes(message.materialize().asInt32List()));
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
                        (e[RecognitionConstants.confidenceInClassKey] * 100) > 40)
                    .map((e) => _formDetection(
                        modelResult: e,
                        screenHeight: height,
                        screenWidth: width))
                    .toList() ?? [];
          });
          final transferableData = TransferableTypedData.fromList(
              [Int32List.fromList(json.encode(detections).codeUnits)]);
          port.send(transferableData);
        }
      });
    }, _imageDetectionReceivePort.sendPort,
       onError: _errorReceivePort.sendPort
    );
  }

  @override
  Future<void> initRecognitionService() async {
    await Tflite.loadModel(
        model: "assets/detection/ssd_mobilenet.tflite",
        labels: "assets/detection/ssd_mobilenet.txt");
    _imageDetectionInitCompleter = Completer.sync();
    _imageDetectionCompleter = Completer.sync();
    await _spawnDetectionOnImageIsolate();
    _frameDetectionCompleter = Completer.sync();
    _frameDetectionInitCompleter = Completer.sync();
    await _spawnDetectionOnFrameIsolate();
  }

  @override
  Future<void> disposeRecognitionService() async {
    await Tflite.close();
    _imageDetectionSubscription?.cancel();
    _imageDetectionIsolate?.kill();
    _frameDetectionSubscription?.cancel();
    _frameDetectionIsolate?.kill();
  }

  @override
  Future<List<Detection>> findDetectionsOnPhoto(
      XFile photo, Size screenSize) async {
    await _imageDetectionInitCompleter.future;
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
  Future<List<Detection>> findDetectionsOnFrame(
      {required List<Uint8List> frame,
      required Size screenSize,
      required int height,
      required int width}) async {
    await _frameDetectionInitCompleter.future;
    final data = [
      model,
      screenSize.height,
      screenSize.width,
      height,
      width,
    ];
    final transferableData = TransferableTypedData.fromList(
        [Int32List.fromList(jsonEncode(data).codeUnits)]);
    _sendPortToFrameDetectionIsolate.send(frame);
    _sendPortToFrameDetectionIsolate.send(transferableData);
    await _frameDetectionCompleter.future;
    _frameDetectionCompleter = Completer.sync();
    return _lastDetectionsOnFrame;
  }

  @override
  Stream get errorStream => _errorReceivePort.asBroadcastStream();
}
