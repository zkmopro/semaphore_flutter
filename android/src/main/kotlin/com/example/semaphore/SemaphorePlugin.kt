package com.example.semaphore

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import uniffi.mopro.*

/** SemaphorePlugin */
class SemaphorePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
  private var identity: Identity? = null
  private var group: Group? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "semaphore")
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
      "group.init" -> {
        try {
          val membersArg = call.arguments
          if (membersArg !is List<*>) {
              result.error("INVALID_ARGUMENT", "Expected a list of Uint8List", null)
              return
          }

          val members = membersArg.mapNotNull { element ->
              when (element) {
                  is ByteArray -> element
                  is List<*> -> element.mapNotNull { (it as? Number)?.toByte() }.toByteArray()
                  else -> null
              }
          }

          if (members.isEmpty()) {
              result.error("INVALID_ARGUMENT", "Could not parse members", null)
              return
          }
          // Convert List<List<Int>> to List<ByteArray>
          val membersData = members.map { member -> member.map { it.toByte() }.toByteArray() }
          group = Group(membersData)
          result.success(null)
        } catch (e: Exception) {
          result.error("GROUP_INIT_ERROR", "Failed to initialize group: ${e.message}", null)
        }
      }
      "group.root" -> {
        result.success(group?.root())
      }
      "group.depth" -> {
        result.success(group?.depth())
      }
      "group.members" -> {
        try {
          val members = group?.members()
          result.success(members)
        } catch (e: Exception) {
          result.error("GROUP_GET_MEMBERS_ERROR", "Failed to get members: ${e.message}", null)
        }
      }
      "group.indexOf" -> {
        try {
          val member = call.arguments
          if (member !is ByteArray) {
            result.error("INVALID_ARGUMENT", "Expected a Uint8List", null)
            return
          }
          val index = group?.indexOf(member)
          result.success(index)
        } catch (e: Exception) {
          result.error("GROUP_GET_INDEX_ERROR", "Failed to get index: ${e.message}", null)
        }
      }
      "group.addMember" -> {
        try {
          val member = call.arguments
          if (member !is ByteArray) {
            result.error("INVALID_ARGUMENT", "Expected a Uint8List", null)
            return
          }
          group?.addMember(member)
          result.success(null)
        } catch (e: Exception) {
          result.error("GROUP_ADD_MEMBER_ERROR", "Failed to add member: ${e.message}", null)
        }
      }
      "group.addMembers" -> {
        try {
          val membersArg = call.arguments
          if (membersArg !is List<*>) {
              result.error("INVALID_ARGUMENT", "Expected a list of Uint8List", null)
              return
          }

          val members = membersArg.mapNotNull { element ->
              when (element) {
                  is ByteArray -> element
                  is List<*> -> element.mapNotNull { (it as? Number)?.toByte() }.toByteArray()
                  else -> null
              }
          }

          if (members.isEmpty()) {
              result.error("INVALID_ARGUMENT", "Could not parse members", null)
              return
          }
          // Convert List<List<Int>> to List<ByteArray>
          val membersData = members.map { member -> member.map { it.toByte() }.toByteArray() }
          group?.addMembers(membersData)
          result.success(null)
        } catch (e: Exception) {
          result.error("GROUP_ADD_MEMBERS_ERROR", "Failed to add members: ${e.message}", null)
        }
      }
      "group.updateMember" -> {
        try {
          val args = call.arguments
          if (args !is Map<*, *>) {
            result.error("INVALID_ARGUMENT", "Expected a map", null)
            return
          }
          val index = args["index"] as? Int
          val member = args["member"] as? ByteArray
          if (index == null || member == null) {
            result.error("INVALID_ARGUMENT", "Expected index and member", null)
            return
          }
          group?.updateMember(index.toUInt(), member)
          result.success(null)
        } catch (e: Exception) {
          result.error("GROUP_UPDATE_MEMBER_ERROR", "Failed to update member: ${e.message}", null)
        }
      }
      "group.removeMember" -> {
        try {
          val index = call.arguments
          if (index !is Int) {
            result.error("INVALID_ARGUMENT", "Expected an index", null)
            return
          }
          group?.removeMember(index.toUInt())
          result.success(null)
        } catch (e: Exception) {
          result.error("GROUP_REMOVE_MEMBER_ERROR", "Failed to remove member: ${e.message}", null)
        }
      }
      "generateSemaphoreProof" -> {
        try {
          val args = call.arguments
          if (args !is Map<*, *>) {
            result.error("INVALID_ARGUMENT", "Expected a map", null)
            return
          }
          val privateKey = args["privateKey"] as? ByteArray
          val members = args["members"] as? List<ByteArray>
          val message = args["message"] as? String
          val scope = args["scope"] as? String
          val treeDepth = args["treeDepth"] as? Int
          if (privateKey == null || members == null || message == null || scope == null || treeDepth == null) {
            result.error("INVALID_ARGUMENT", "Expected privateKey, members, message, scope, and treeDepth", null)
            return
          }
          val identity = try {
            Identity(privateKey)
          } catch (e: Exception) {
            result.error("INVALID_ARGUMENT", "Failed to create identity: ${e.message}", null)
            return
          }
          val group = try {
            Group(members)
          } catch (e: Exception) {
            result.error("INVALID_ARGUMENT", "Failed to create group: ${e.message}", null)
            return
          }
          val proof = try {
            generateSemaphoreProof(identity, group, message, scope, treeDepth.toUShort())
          } catch (e: Exception) {
            result.error("GENERATE_SEMAPHORE_PROOF_ERROR", "Failed to generate semaphore proof: ${e.message}", null)
            return
          }
          result.success(proof)
        } catch (e: Exception) {
          result.error("GENERATE_SEMAPHORE_PROOF_ERROR", "Failed to generate semaphore proof: ${e.message}", null)
        }
      }
      "verifySemaphoreProof" -> {
        try {
          val proof = call.arguments
          if (proof !is String) {
            result.error("INVALID_ARGUMENT", "Expected a string", null)
            return
          }
          val valid = try {
            verifySemaphoreProof(proof)
          } catch (e: Exception) {
            result.error("VERIFY_SEMAPHORE_PROOF_ERROR", "Failed to verify semaphore proof: ${e.message}", null)
            return
          }
          result.success(valid)
        } catch (e: Exception) {
          result.error("VERIFY_SEMAPHORE_PROOF_ERROR", "Failed to verify semaphore proof: ${e.message}", null)
        }
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
