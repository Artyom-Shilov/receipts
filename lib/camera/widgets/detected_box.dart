import 'dart:math';

import 'package:flutter/material.dart';
import 'package:receipts/common/models/detection.dart';


class DetectedBox extends StatelessWidget {
  const DetectedBox({Key? key, required this.detection}) : super(key: key);

  final Detection detection;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: max(0, detection.x),
      top: max(0, detection.y),
      width: detection.width,
      height: detection.height,
      child: Container(
        padding: const EdgeInsets.only(top: 5.0, left: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromRGBO(37, 213, 253, 1.0),
            width: 3.0,
          ),
        ),
        child: Text(
          '${detection.detectedClass} ${detection.confidence}',
          style: const TextStyle(
            color: Color.fromRGBO(37, 213, 253, 1.0),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
