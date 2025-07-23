import 'dart:typed_data';

import 'package:mopro_flutter_package/mopro_flutter_package.dart';

class Identity {
  final Uint8List _privateKey;
  final _moproFlutterPlugin = MoproFlutterPackage();

  Identity(this._privateKey) {
    _moproFlutterPlugin.createIdentity(_privateKey);
  }

  Future<String> commitment() async {
    return await _moproFlutterPlugin.getIdentityCommitment();
  }

  Future<Uint8List> privateKey() async {
    return await _moproFlutterPlugin.getIdentityPrivateKey();
  }

  Future<String> secretScalar() async {
    return await _moproFlutterPlugin.getIdentitySecretScalar();
  }

  Future<Uint8List> toElement() async {
    return await _moproFlutterPlugin.getIdentityToElement();
  }
}
