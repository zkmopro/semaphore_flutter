import 'dart:typed_data';

import 'package:mopro_flutter_package/mopro_flutter_package.dart';

class Identity {
  Uint8List _privateKey;

  Identity(this._privateKey) {
    _privateKey = _privateKey;
  }

  Future<String> commitment() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createIdentity(_privateKey);
    return await moproFlutterPlugin.getIdentityCommitment();
  }

  Future<Uint8List> privateKey() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createIdentity(_privateKey);
    return await moproFlutterPlugin.getIdentityPrivateKey();
  }

  Future<String> secretScalar() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createIdentity(_privateKey);
    return await moproFlutterPlugin.getIdentitySecretScalar();
  }

  Future<Uint8List> toElement() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createIdentity(_privateKey);
    return await moproFlutterPlugin.getIdentityToElement();
  }
}

class Group {
  List<Uint8List> _members;

  Group(this._members) {
    _members = _members;
  }

  Future<Uint8List> root() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createGroup(_members);
    return await moproFlutterPlugin.getGroupRoot();
  }

  Future<List<Uint8List>> members() async {
    final moproFlutterPlugin = MoproFlutterPackage();
    moproFlutterPlugin.createGroup(_members);
    return await moproFlutterPlugin.getGroupMembers();
  }
}

Future<String> generateSemaphoreProof(
  Identity identity,
  Group group,
  String message,
  String scope,
  int treeDepth,
) async {
  final privateKey = await identity.privateKey();
  final groupMembers = await group.members();
  final moproFlutterPlugin = MoproFlutterPackage();
  return await moproFlutterPlugin.generateSemaphoreProof(
    privateKey,
    groupMembers,
    message,
    scope,
    treeDepth,
  );
}

Future<bool> verifySemaphoreProof(String proof) async {
  final moproFlutterPlugin = MoproFlutterPackage();
  return await moproFlutterPlugin.verifySemaphoreProof(proof);
}
