import 'dart:math';

import 'package:flutter/material.dart';


class DetectedPositionedBox extends StatelessWidget {
  const DetectedPositionedBox({Key? key, required this.detection, required this.previewH, required this.previewW, required this.screenH, required this.screenW}) : super(key: key);

  final dynamic detection;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;

  @override
  Widget build(BuildContext context) {
    var _x = detection["rect"]["x"];
    var _w = detection["rect"]["w"];
    var _y = detection["rect"]["y"];
    var _h = detection["rect"]["h"];
    var scaleW, scaleH, x, y, w, h;

    if (screenH / screenW > previewH / previewW) {
      scaleW = screenH / previewH * previewW;
      scaleH = screenH;
      var difW = (scaleW - screenW) / scaleW;
      x = (_x - difW / 2) * scaleW;
      w = _w * scaleW;
      if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
      y = _y * scaleH;
      h = _h * scaleH;
    } else {
      scaleH = screenW / previewW * previewH;
      scaleW = screenW;
      var difH = (scaleH - screenH) / scaleH;
      x = _x * scaleW;
      w = _w * scaleW;
      y = (_y - difH / 2) * scaleH;
      h = _h * scaleH;
      if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
    }

    return Positioned(
      left: max(0, x),
      top: max(0, y),
      width: w,
      height: h,
      child: Container(
        padding: EdgeInsets.only(top: 5.0, left: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromRGBO(37, 213, 253, 1.0),
            width: 3.0,
          ),
        ),
        child: Text(
          "${detection["detectedClass"]} ${(detection["confidenceInClass"] * 100).toStringAsFixed(0)}%",
          style: TextStyle(
            color: Color.fromRGBO(37, 213, 253, 1.0),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
