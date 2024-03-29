// Autogenerated from Pigeon (v16.0.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.example.ble_info

import android.bluetooth.BluetoothAdapter
import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.common.StandardMessageCodec
import java.io.ByteArrayOutputStream
import java.nio.ByteBuffer

class BleApiImpl : BleApi {

  private lateinit var devices: MutableSet<BleDevice>

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  private lateinit var scannerCallback: ScanCallback
  lateinit var scanner: BluetoothLeScanner

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun startScanning() {
    devices = mutableSetOf()
    scannerCallback = getScanCallback(devices)
    scanner = BluetoothAdapter.getDefaultAdapter().bluetoothLeScanner
    scanner.startScan(scannerCallback)
    Log.d("scan", "scan start send")
  }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  override fun stopScanning() {
    scanner.stopScan(scannerCallback)
    Log.d("scan", "scan stop send")
  }

  override fun isBluetoothEnable(): Boolean {
    Log.d("scan", "bluetooth check")
    return BluetoothAdapter.getDefaultAdapter().isEnabled
  }

  @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
  private fun getScanCallback(devices: MutableSet<BleDevice>): ScanCallback {
    return object : ScanCallback() {
      override fun onScanResult(callbackType: Int, result: ScanResult) {
        val name: String =
          if (result.scanRecord == null || result.scanRecord!!.deviceName == null) {
            ""
          } else {
            result.scanRecord!!.deviceName!!
          }

        val mac: String = if (result.device == null || result.device!!.address == null) {
          ""
        } else {
          result.device!!.address!!
        }
        devices.add(BleDevice(name, mac))
      }

      override fun onBatchScanResults(results: List<ScanResult?>?) { Log.d("scan", "batch") }

      override fun onScanFailed(errorCode: Int) { Log.d("scan", "fail") }
    }
  }

  override fun getNearestBleDevices(): List<BleDevice> {
    return devices.toList()
  }

}

private fun wrapResult(result: Any?): List<Any?> {
  return listOf(result)
}

private fun wrapError(exception: Throwable): List<Any?> {
  if (exception is FlutterError) {
    return listOf(
      exception.code,
      exception.message,
      exception.details
    )
  } else {
    return listOf(
      exception.javaClass.simpleName,
      exception.toString(),
      "Cause: " + exception.cause + ", Stacktrace: " + Log.getStackTraceString(exception)
    )
  }
}

/**
 * Error class for passing custom error details to Flutter via a thrown PlatformException.
 * @property code The error code.
 * @property message The error message.
 * @property details The error details. Must be a datatype supported by the api codec.
 */
class FlutterError (
  val code: String,
  override val message: String? = null,
  val details: Any? = null
) : Throwable()

/** Generated class from Pigeon that represents data sent in messages. */
data class BleDevice (
  val deviceName: String,
  val mac: String

) {



  companion object {
    @Suppress("UNCHECKED_CAST")
    fun fromList(list: List<Any?>): BleDevice {
      val deviceName = list[0] as String
      val mac = list[1] as String
      return BleDevice(deviceName, mac)
    }
  }
  fun toList(): List<Any?> {
    return listOf<Any?>(
      deviceName,
      mac,
    )
  }

  override fun equals(other: Any?): Boolean {
    if (this === other) return true
    if (javaClass != other?.javaClass) return false

    other as BleDevice

    if (deviceName != other.deviceName) return false
    if (mac != other.mac) return false

    return true
  }

  override fun hashCode(): Int {
    var result = deviceName.hashCode()
    result = 31 * result + mac.hashCode()
    return result
  }
}
@Suppress("UNCHECKED_CAST")
private object BleApiCodec : StandardMessageCodec() {
  override fun readValueOfType(type: Byte, buffer: ByteBuffer): Any? {
    return when (type) {
      128.toByte() -> {
        return (readValue(buffer) as? List<Any?>)?.let {
          BleDevice.fromList(it)
        }
      }
      else -> super.readValueOfType(type, buffer)
    }
  }
  override fun writeValue(stream: ByteArrayOutputStream, value: Any?)   {
    when (value) {
      is BleDevice -> {
        stream.write(128)
        writeValue(stream, value.toList())
      }
      else -> super.writeValue(stream, value)
    }
  }
}

/** Generated interface from Pigeon that represents a handler of messages from Flutter. */
interface BleApi {
  fun getNearestBleDevices(): List<BleDevice>
  fun startScanning()
  fun stopScanning()
  fun isBluetoothEnable(): Boolean

  companion object {
    /** The codec used by BleApi. */
    val codec: MessageCodec<Any?> by lazy {
      BleApiCodec
    }
    /** Sets up an instance of `BleApi` to handle messages through the `binaryMessenger`. */
    @Suppress("UNCHECKED_CAST")
    fun setUp(binaryMessenger: BinaryMessenger, api: BleApi?) {
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.ble_info.BleApi.getNearestBleDevices", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.getNearestBleDevices())
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.ble_info.BleApi.startScanning", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.startScanning()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.ble_info.BleApi.stopScanning", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              api.stopScanning()
              wrapped = listOf<Any?>(null)
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
      run {
        val channel = BasicMessageChannel<Any?>(binaryMessenger, "dev.flutter.pigeon.ble_info.BleApi.isBluetoothEnable", codec)
        if (api != null) {
          channel.setMessageHandler { _, reply ->
            var wrapped: List<Any?>
            try {
              wrapped = listOf<Any?>(api.isBluetoothEnable())
            } catch (exception: Throwable) {
              wrapped = wrapError(exception)
            }
            reply.reply(wrapped)
          }
        } else {
          channel.setMessageHandler(null)
        }
      }
    }
  }
}
