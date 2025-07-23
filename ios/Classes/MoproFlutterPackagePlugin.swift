import Flutter
import UIKit
import moproFFI

public class MoproFlutterPackagePlugin: NSObject, FlutterPlugin {
  private var identity: Identity? = nil
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

    // case "group.init":
    //   let members = (call.arguments as? [String: Any])?["members"] as? [FlutterStandardTypedData]
    //   GroupManager.shared.initGroup(members: members?.map { $0.data } ?? [])
    //   result(nil)

    // case "group.root":
    //   result(GroupManager.shared.root())

    // case "proof.generate":
    //   // Extract args and call into Rust or native logic
    //   result(ProofManager.generate(...))

    // case "proof.verify":
    //   result(ProofManager.verify(...))

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
