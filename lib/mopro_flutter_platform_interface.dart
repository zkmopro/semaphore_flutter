import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';

import 'mopro_flutter_types.dart';

abstract class MoproFlutterPlatformInterface extends PlatformInterface {
  MoproFlutterPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static MoproFlutterPlatformInterface _instance =
      MoproFlutterPlatformInterfaceDefault();

  static MoproFlutterPlatformInterface get instance => _instance;

  static set instance(MoproFlutterPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> initIdentity(Uint8List secret) {
    throw UnimplementedError('initIdentity() has not been implemented.');
  }

  Future<String> getIdentityCommitment() {
    throw UnimplementedError(
      'getIdentityCommitment() has not been implemented.',
    );
  }

  Future<Uint8List> getIdentityPrivateKey() {
    throw UnimplementedError(
      'getIdentityPrivateKey() has not been implemented.',
    );
  }

  Future<String> getIdentitySecretScalar() {
    throw UnimplementedError(
      'getIdentitySecretScalar() has not been implemented.',
    );
  }

  Future<Uint8List> getIdentityToElement() {
    throw UnimplementedError(
      'getIdentityToElement() has not been implemented.',
    );
  }

  Future<Group> createGroup(List<Uint8List> members) {
    throw UnimplementedError('createGroup() has not been implemented.');
  }

  Future<Uint8List> getGroupRoot() {
    throw UnimplementedError('getGroupRoot() has not been implemented.');
  }

  Future<int> getGroupDepth() {
    throw UnimplementedError('getGroupDepth() has not been implemented.');
  }

  Future<List<Uint8List>> getGroupMembers() {
    throw UnimplementedError('getGroupMembers() has not been implemented.');
  }

  Future<int> getGroupIndexOf(Uint8List member) {
    throw UnimplementedError('getGroupIndexOf() has not been implemented.');
  }

  Future<void> addGroupMember(Uint8List member) {
    throw UnimplementedError('addGroupMember() has not been implemented.');
  }

  Future<void> addGroupMembers(List<Uint8List> members) {
    throw UnimplementedError('addGroupMembers() has not been implemented.');
  }

  Future<void> updateGroupMember(Uint8List member, int index) {
    throw UnimplementedError('updateGroupMember() has not been implemented.');
  }

  Future<void> removeGroupMember(int index) {
    throw UnimplementedError('removeGroupMember() has not been implemented.');
  }

  Future<String> generateSemaphoreProof(
    String privateKey,
    List<Uint8List> members,
    String message,
    String scope,
    int treeDepth,
  ) {
    throw UnimplementedError(
      'generateSemaphoreProof() has not been implemented.',
    );
  }

  Future<bool> verifySemaphoreProof(
    String proof,
  ) {
    throw UnimplementedError(
      'verifySemaphoreProof() has not been implemented.',
    );
  }
}

// Concrete implementation for the default instance
class MoproFlutterPlatformInterfaceDefault
    extends MoproFlutterPlatformInterface {
  // @override
  // Future<GenerateProofResult> generateProof(String zkeyPath, String inputs) {
  //   throw UnimplementedError('generateProof() has not been implemented.');
  // }

  @override
  Future<void> initIdentity(Uint8List secret) {
    throw UnimplementedError('initIdentity() has not been implemented.');
  }

  @override
  Future<String> getIdentityCommitment() {
    throw UnimplementedError(
      'getIdentityCommitment() has not been implemented.',
    );
  }

  @override
  Future<Uint8List> getIdentityPrivateKey() {
    throw UnimplementedError(
      'getIdentityPrivateKey() has not been implemented.',
    );
  }

  @override
  Future<String> getIdentitySecretScalar() {
    throw UnimplementedError(
      'getIdentitySecretScalar() has not been implemented.',
    );
  }

  @override
  Future<Uint8List> getIdentityToElement() {
    throw UnimplementedError(
      'getIdentityToElement() has not been implemented.',
    );
  }

  @override
  Future<Group> createGroup(List<Uint8List> members) {
    throw UnimplementedError('createGroup() has not been implemented.');
  }

  @override
  Future<Uint8List> getGroupRoot() {
    throw UnimplementedError('getGroupRoot() has not been implemented.');
  }

  @override
  Future<int> getGroupDepth() {
    throw UnimplementedError('getGroupDepth() has not been implemented.');
  }

  @override
  Future<List<Uint8List>> getGroupMembers() {
    throw UnimplementedError('getGroupMembers() has not been implemented.');
  }

  @override
  Future<int> getGroupIndexOf(Uint8List member) {
    throw UnimplementedError('getGroupIndexOf() has not been implemented.');
  }

  @override
  Future<void> addGroupMember(Uint8List member) {
    throw UnimplementedError('addGroupMember() has not been implemented.');
  }

  @override
  Future<void> addGroupMembers(List<Uint8List> members) {
    throw UnimplementedError('addGroupMembers() has not been implemented.');
  }

  @override
  Future<void> updateGroupMember(Uint8List member, int index) {
    throw UnimplementedError('updateGroupMember() has not been implemented.');
  }

  @override
  Future<void> removeGroupMember(int index) {
    throw UnimplementedError('removeGroupMember() has not been implemented.');
  }

  @override
  Future<String> generateSemaphoreProof(String privateKey, List<Uint8List> members, String message, String scope, int treeDepth) {
    throw UnimplementedError('generateSemaphoreProof() has not been implemented.');
  }

  @override
  Future<bool> verifySemaphoreProof(String proof) {
    throw UnimplementedError('verifySemaphoreProof() has not been implemented.');
  }
}
