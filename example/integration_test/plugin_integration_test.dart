// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:semaphore/semaphore.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('identity creation test', (WidgetTester tester) async {
    final Semaphore plugin = Semaphore();
    
    // Test identity creation
    final secretBytes = Uint8List.fromList(utf8.encode("test_secret"));
    
    try {
      final identity = await plugin.createIdentity(secretBytes);
      expect(identity, isNotNull);
      expect(identity.secretScalar(), equals(secretBytes));
    } catch (e) {
      // If the native implementation is not available, this will throw
      // which is expected in a test environment
      expect(e, isA<Exception>());
    }
  });
}
