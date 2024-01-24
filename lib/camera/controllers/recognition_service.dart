import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:receipts/camera/controllers/base_recognition_service.dart';
import 'package:receipts/common/constants/recognition_constants.dart';
import 'package:receipts/common/models/detection.dart';

class RecognitionService implements BaseRecognitionService {

  @override
  Future<void> initRecognitionService() async {
    await Tflite.loadModel(
        model: "assets/detection/ssd_mobilenet.tflite",
        labels: "assets/detection/ssd_mobilenet.txt");
  }

  @override
  Future<void> disposeRecognitionService() async {
    await Tflite.close();
  }

  @override
  Future<List<Detection>> findDetectionsOnPhoto(XFile photo, Size screenSize) async {
    List<Detection> detections = [];
    await Tflite.detectObjectOnImage(
            model: RecognitionConstants.modelName,
            path: photo.path,
            numResultsPerClass: 1,
            threshold: 0.1,
            blockSize: 128)
        .then((recognitions) {
      detections = recognitions
              ?.where((e) => (e[RecognitionConstants.confidenceInClassKey] * 100) > 40)
              .map((e) => _formDetection(e, screenSize))
              .toList() ?? [];
    });
    return detections;
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
      detections = recognitions
          ?.where((e) => (e[RecognitionConstants.confidenceInClassKey] * 100) > 40)
          .map((e) => _formDetection(e, screenSize))
          .toList() ?? [];
    });
    return detections;
  }

  Detection _formDetection(dynamic modelResult, Size screenSize) {
    final modelX = modelResult[RecognitionConstants.rectKey][RecognitionConstants.xKey];
    final modelWidth = modelResult[RecognitionConstants.rectKey][RecognitionConstants.wKey];
    final modelY = modelResult[RecognitionConstants.rectKey][RecognitionConstants.yKey];
    final modelHeight = modelResult[RecognitionConstants.rectKey][RecognitionConstants.hKey];

    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

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
        '${(modelResult[RecognitionConstants.confidenceInClassKey] * 100).toStringAsFixed(0)}%');
  }
}