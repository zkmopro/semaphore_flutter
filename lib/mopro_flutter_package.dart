import 'dart:typed_data';
import 'package:flutter/services.dart';

import 'mopro_flutter_types.dart';

export 'mopro_flutter_types.dart';

class MoproFlutterPackage {
  static const MethodChannel _channel = MethodChannel('mopro_flutter_package');

  Future<Identity> createIdentity(Uint8List privateKey) async {
    await _channel.invokeMethod('identity.init', {'privateKey': privateKey});
    return Identity(privateKey);
  }

  Future<String> getIdentityCommitment() async {
    final result = await _channel.invokeMethod<String>('identity.commitment');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Identity commitment returned null result',
      );
    }
    return result;
  }

  Future<Uint8List> getIdentityPrivateKey() async {
    final result = await _channel.invokeMethod<Uint8List>(
      'identity.privateKey',
    );
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Identity private key returned null result',
      );
    }
    return result;
  }

  Future<String> getIdentitySecretScalar() async {
    final result = await _channel.invokeMethod<String>('identity.secretScalar');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Identity secret scalar returned null result',
      );
    }
    return result;
  }

  Future<Uint8List> getIdentityToElement() async {
    final result = await _channel.invokeMethod<Uint8List>('identity.toElement');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Identity to element returned null result',
      );
    }
    return result;
  }

  Future<Group> createGroup(List<Uint8List> members) async {
    // Convert Uint8List to List<int> for proper serialization
    final membersAsLists = members.map((member) => member.toList()).toList();
    await _channel.invokeMethod('group.init', membersAsLists);
    return Group(members);
  }

  Future<Uint8List> getGroupRoot() async {
    final result = await _channel.invokeMethod<Uint8List>('group.root');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Group root returned null result',
      );
    }
    return result;
  }

  Future<int> getGroupDepth() async {
    final result = await _channel.invokeMethod<int>('group.depth');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Group depth returned null result',
      );
    }
    return result;
  }

  Future<List<Uint8List>> getGroupMembers() async {
    print("getGroupMembers");
    final result = await _channel.invokeMethod('group.members');
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Group members returned null result',
      );
    }
    return (result as List)
        .where((e) => e != null)
        .map((e) => Uint8List.fromList(List<int>.from(e)))
        .toList();
  }

  Future<int> getGroupIndexOf(Uint8List member) async {
    final result = await _channel.invokeMethod<int>('group.indexOf', member);
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Group index returned null result',
      );
    }
    return result;
  }

  Future<void> addGroupMember(Uint8List member) async {
    await _channel.invokeMethod('group.addMember', member);
  }

  Future<void> addGroupMembers(List<Uint8List> members) async {
    await _channel.invokeMethod('group.addMembers', members);
  }

  Future<void> updateGroupMember(Uint8List member, int index) async {
    await _channel.invokeMethod('group.updateMember', {
      'member': member,
      'index': index,
    });
  }

  Future<void> removeGroupMember(int index) async {
    await _channel.invokeMethod('group.removeMember', index);
  }

  Future<String> generateSemaphoreProof(
    Uint8List privateKey,
    List<Uint8List> members,
    String message,
    String scope,
    int treeDepth,
  ) async {
    final result = await _channel
        .invokeMethod<String>('generateSemaphoreProof', {
          'privateKey': privateKey,
          'members': members,
          'message': message,
          'scope': scope,
          'treeDepth': treeDepth,
        });
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Semaphore proof returned null result',
      );
    }
    return result;
  }

  Future<bool> verifySemaphoreProof(String proof) async {
    final result = await _channel.invokeMethod<bool>(
      'verifySemaphoreProof',
      proof,
    );
    if (result == null) {
      throw PlatformException(
        code: 'NULL_RESULT',
        message: 'Semaphore proof verification returned null result',
      );
    }
    return result;
  }
}
