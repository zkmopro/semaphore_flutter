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

  // Future<GenerateProofResult> generateProof(String zkeyPath, String inputs) {
  //   throw UnimplementedError('generateProof() has not been implemented.');
  // }

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
}
