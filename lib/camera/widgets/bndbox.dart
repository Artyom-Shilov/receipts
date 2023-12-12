import 'package:flutter/material.dart';
import 'package:receipts/camera/widgets/detected_positioned_box.dart';

class BndBox extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  const BndBox(this.results, this.previewH, this.previewW, this.screenH, this.screenW);

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        for (final detection in results)
          DetectedPositionedBox(detection: detection, previewH: previewH, previewW: previewW,
          screenH: screenH, screenW: screenW)
      ]
    );
  }
}
