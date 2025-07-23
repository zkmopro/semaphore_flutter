package com.example.mopro_flutter_package

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import uniffi.mopro.*

/** MoproFlutterPackagePlugin */
class MoproFlutterPackagePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  private var identity: Identity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mopro_flutter_package")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "identity.init" -> {
        val privateKey = call.argument<ByteArray>("privateKey") ?: return result.error(
            "ARGUMENT_ERROR",
            "Missing privateKey",
            null
        )
        identity = Identity(privateKey)
        result.success(null)
      }
      "identity.commitment" -> {
        result.success(identity?.commitment())
      }
      "identity.privateKey" -> {
        result.success(identity?.privateKey())
      }
      "identity.secretScalar" -> {
        result.success(identity?.secretScalar())
      }
      "identity.toElement" -> {
        result.success(identity?.toElement())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
