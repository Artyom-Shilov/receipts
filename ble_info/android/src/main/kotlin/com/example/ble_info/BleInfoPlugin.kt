package com.example.ble_info

import io.flutter.embedding.engine.plugins.FlutterPlugin

/** BleInfoPlugin */
class BleInfoPlugin: FlutterPlugin {

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    BleApi.setUp(flutterPluginBinding.binaryMessenger, BleApiImpl())
  }


  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}
}
