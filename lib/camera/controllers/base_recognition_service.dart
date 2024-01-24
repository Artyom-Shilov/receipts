import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipts/common/models/detection.dart';

abstract interface class BaseRecognitionService {

  Future<void> initRecognitionService();

  Future<List<Detection>> findDetectionsOnPhoto(XFile photo, Size screenSize);

  Future<List<Detection>> findDetectionsOnFrame(
      {required List<Uint8List> frame,
      required Size screenSize,
      required int height,
      required int width});

  Future<void> disposeRecognitionService();
}