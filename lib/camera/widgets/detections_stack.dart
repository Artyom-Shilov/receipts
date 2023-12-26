import 'package:flutter/material.dart';
import 'package:receipts/camera/widgets/detected_box.dart';
import 'package:receipts/common/models/detection.dart';

class DetectionStack extends StatelessWidget {

  const DetectionStack({super.key, required this.detections});

  final List<Detection> detections;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final detection in detections)
          DetectedBox(detection: detection)
      ]
    );
  }
}
