import 'dart:typed_data';

import 'package:semaphore/semaphore.dart';

class Identity {
  Uint8List _privateKey;

  Identity(this._privateKey) {
    _privateKey = _privateKey;
  }

  Future<String> commitment() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createIdentity(_privateKey);
    return await semaphorePlugin.getIdentityCommitment();
  }

  Future<Uint8List> privateKey() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createIdentity(_privateKey);
    return await semaphorePlugin.getIdentityPrivateKey();
  }

  Future<String> secretScalar() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createIdentity(_privateKey);
    return await semaphorePlugin.getIdentitySecretScalar();
  }

  Future<Uint8List> toElement() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createIdentity(_privateKey);
    return await semaphorePlugin.getIdentityToElement();
  }
}

class Group {
  List<Uint8List> _members;

  Group(this._members) {
    _members = _members;
  }

  Future<Uint8List> root() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createGroup(_members);
    return await semaphorePlugin.getGroupRoot();
  }

  Future<List<Uint8List>> members() async {
    final semaphorePlugin = Semaphore();
    semaphorePlugin.createGroup(_members);
    return await semaphorePlugin.getGroupMembers();
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
  final semaphorePlugin = Semaphore();
  return await semaphorePlugin.generateSemaphoreProof(
    privateKey,
    groupMembers,
    message,
    scope,
    treeDepth,
  );
}

Future<bool> verifySemaphoreProof(String proof) async {
  final semaphorePlugin = Semaphore();
  return await semaphorePlugin.verifySemaphoreProof(proof);
}
