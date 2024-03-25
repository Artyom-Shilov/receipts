import 'dart:convert';

import 'package:flutter/services.dart';

class UtilLogic {

  static Future<void> fixPortraitUpOrientation() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  static Future<void> unfixOrientation() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
  }

  static String uInt8ListToString(Uint8List bytes) {
    return base64Encode(bytes);
  }

  static Uint8List? stringToUInt8List(String? string) {
    if (string == null || string.isEmpty) {
      return null;
    }
    return base64Decode(string);
  }
}