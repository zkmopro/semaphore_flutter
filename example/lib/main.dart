import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:mopro_flutter_package/mopro_flutter_package.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Ready';

  Future<void> _initIdentity() async {
    try {
      setState(() {
        _status = 'Initializing identity...';
      });

      // Create a sample secret (32 bytes)
      final privateKey = utf8.encode("secret");
      print(privateKey);

      final identity = Identity(privateKey);
      print(await identity.commitment());
      print(await identity.privateKey());
      print(await identity.secretScalar());
      print(await identity.toElement());
      final commitment = await identity.commitment();

      setState(() {
        _status =
            'Identity created successfully! Commitment: $commitment';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mopro Flutter Package Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('Mopro Flutter Package Example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _initIdentity,
                child: const Text('Init Identity'),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
