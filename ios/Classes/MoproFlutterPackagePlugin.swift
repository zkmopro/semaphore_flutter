import Flutter
import UIKit
import moproFFI

public class MoproFlutterPackagePlugin: NSObject, FlutterPlugin {
  private var identity: Identity? = nil
  private var group: Group? = nil
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "mopro_flutter_package", binaryMessenger: registrar.messenger())
    let instance = MoproFlutterPackagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "identity.init":
      if let args = call.arguments as? [String: Any],
        let privateKey = args["privateKey"] as? FlutterStandardTypedData
      {
        identity = Identity(privateKey: privateKey.data)
        result(nil)
      }

    case "identity.commitment":
      result(identity?.commitment())

    case "identity.privateKey":
      result(identity?.privateKey())

    case "identity.secretScalar":
      result(identity?.secretScalar())

    case "identity.toElement":
      result(identity?.toElement())

    case "group.init":
      guard let members = call.arguments as? [[UInt8]] else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected list of list of UInt8", details: nil))
        return
      }

      do {
        var membersData: [Data] = []
        for member in members {
          membersData.append(Data(member))
        }
        group = Group(members: membersData)
        result(nil)  // success
      } catch {
        result(
          FlutterError(
            code: "GroupInitError", message: "Failed to initialize group: \(error)", details: nil))
      }

    case "group.root":
      result(group?.root())

    case "group.depth":
      result(group?.depth())

    case "group.members":
      do {
        let members = try group?.members()
        result(members)
      } catch {
        result(
          FlutterError(
            code: "GroupGetMembersError", message: "Failed to get members: \(error)", details: nil))
      }

    case "group.indexOf":
      guard let member = call.arguments as? FlutterStandardTypedData else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected list of UInt8", details: nil))
        return
      }

      do {
        result(group?.indexOf(member: member.data))
      } catch {
        result(
          FlutterError(
            code: "GroupGetIndexError", message: "Failed to get index: \(error)", details: nil))
      }

    case "group.addMember":
      guard let member = call.arguments as? FlutterStandardTypedData else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected list of UInt8", details: nil))
        return
      }

      do {
        try group?.addMember(member: member.data)
        result(nil)
      } catch {
        result(
          FlutterError(
            code: "GroupAddMemberError", message: "Failed to add member: \(error)", details: nil))
      }

    case "group.addMembers":
      guard let members = call.arguments as? [FlutterStandardTypedData] else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected list of list of UInt8", details: nil))
        return
      }

      do {
        var membersData: [Data] = []
        for member in members {
          membersData.append(Data(member.data))
        }
        try group?.addMembers(members: membersData)
        result(nil)
      } catch {
        result(
          FlutterError(
            code: "GroupAddMembersError", message: "Failed to add members: \(error)", details: nil))
      }

    case "group.updateMember":
      if let args = call.arguments as? [String: Any],
        let index = args["index"] as? UInt32,
        let member = args["member"] as? FlutterStandardTypedData
      {
        do {
          try group?.updateMember(index: index, member: member.data)
          result(nil)
        } catch {
          result(
            FlutterError(
              code: "GroupUpdateMemberError", message: "Failed to update member: \(error)",
              details: nil))
        }
      } else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected index and member", details: nil))
        return
      }

    case "group.removeMember":
      guard let index = call.arguments as? UInt32 else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT", message: "Expected index", details: nil))
        return
      }

      do {
        try group?.removeMember(index: index)
        result(nil)
      } catch {
        result(
          FlutterError(
            code: "GroupRemoveMemberError", message: "Failed to remove member: \(error)",
            details: nil))
      }

    case "generateSemaphoreProof":
      guard let args = call.arguments as? [String: Any],
        let privateKey = args["privateKey"] as? FlutterStandardTypedData,
        let members = args["members"] as? [FlutterStandardTypedData],
        let message = args["message"] as? String,
        let scope = args["scope"] as? String,
        let treeDepth = args["treeDepth"] as? Int
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Expected privateKey, members, message, scope, and treeDepth", details: nil))
        return
      }

      do {
        // Decode your Identity and Group if necessary from `Data`
        let identity = try Identity(privateKey: privateKey.data)
        var membersData: [Data] = []
        for member in members {
          membersData.append(Data(member.data))
        }
        let group = Group(members: membersData)

        // Convert Int to UInt16
        let depth = UInt16(treeDepth)

        // Call the actual Swift function
        let proof = try generateSemaphoreProof(
          identity: identity, group: group, message: message, scope: scope, merkleTreeDepth: depth)

        // Return the proof string directly
        result(proof)
      } catch {
        result(
          FlutterError(
            code: "GenerateSemaphoreProofError",
            message: "Failed to generate semaphore proof: \(error)", details: nil))
      }

    case "verifySemaphoreProof":
      guard let proof = call.arguments as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENT",
            message: "Expected proof", details: nil))
        return
      }

      do {
        let valid = try verifySemaphoreProof(proof: proof)
        result(valid)
      } catch {
        result(
          FlutterError(
            code: "VerifySemaphoreProofError",
            message: "Failed to verify semaphore proof: \(error)", details: nil))
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
