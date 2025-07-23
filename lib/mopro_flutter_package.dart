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
}
