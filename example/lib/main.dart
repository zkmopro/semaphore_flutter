import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:semaphore/semaphore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _status = 'Ready to start';
  bool _isLoading = false;
  String _generatedProof = '';
  bool _proofVerificationResult = false;
  bool _hasGeneratedProof = false;
  
  // Controllers for user input
  final TextEditingController _messageController = TextEditingController(text: 'Hello World');
  final TextEditingController _scopeController = TextEditingController(text: 'test-scope');
  final TextEditingController _privateKey1Controller = TextEditingController(text: 'secret');
  final TextEditingController _privateKey2Controller = TextEditingController(text: 'secret2');
  
  // Store instances for reuse
  Identity? _identity1;
  Identity? _identity2;
  Group? _group;

  @override
  void dispose() {
    _messageController.dispose();
    _scopeController.dispose();
    _privateKey1Controller.dispose();
    _privateKey2Controller.dispose();
    super.dispose();
  }

  Future<void> _initializeIdentities() async {
    try {
      setState(() {
        _isLoading = true;
        _status = 'Creating identities...';
      });

      // Create identities from user input
      final privateKey1 = utf8.encode(_privateKey1Controller.text);
      final privateKey2 = utf8.encode(_privateKey2Controller.text);

      _identity1 = Identity(privateKey1);
      _identity2 = Identity(privateKey2);

      setState(() {
        _status = 'Getting identity elements...';
      });

      // Get identity elements
      final element1 = await _identity1!.toElement();
      final element2 = await _identity2!.toElement();

      setState(() {
        _status = 'Creating group...';
      });

      // Create group
      _group = Group([element1, element2]);
      final groupRoot = await _group!.root();
      final groupMembers = await _group!.members();

      setState(() {
        _isLoading = false;
        _status = '✅ Identities and group created successfully!\n'
            'Group Root: ${groupRoot.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join('')}...\n'
            'Group Members: ${groupMembers.length}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Error creating identities: $e';
      });
    }
  }

  Future<void> _generateProof() async {
    if (_identity1 == null || _group == null) {
      setState(() {
        _status = '❌ Please initialize identities first';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _status = 'Generating semaphore proof...';
      });

      final proof = await generateSemaphoreProof(
        _identity1!,
        _group!,
        _messageController.text,
        _scopeController.text,
        16, // treeDepth
      );

      setState(() {
        _isLoading = false;
        _generatedProof = proof;
        _hasGeneratedProof = true;
        _status = '✅ Proof generated successfully!\n'
            'Message: ${_messageController.text}\n'
            'Scope: ${_scopeController.text}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Error generating proof: $e';
      });
    }
  }

  Future<void> _verifyProof() async {
    if (_generatedProof.isEmpty) {
      setState(() {
        _status = '❌ Please generate a proof first';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _status = 'Verifying proof...';
      });

      final isValid = await verifySemaphoreProof(_generatedProof);

      setState(() {
        _isLoading = false;
        _proofVerificationResult = isValid;
        _status = isValid 
            ? '✅ Proof verification successful!'
            : '❌ Proof verification failed!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = '❌ Error verifying proof: $e';
      });
    }
  }

  Widget _buildInputSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Identity Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _privateKey1Controller,
              decoration: const InputDecoration(
                labelText: 'Private Key 1',
                border: OutlineInputBorder(),
                helperText: 'Secret for first identity',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _privateKey2Controller,
              decoration: const InputDecoration(
                labelText: 'Private Key 2',
                border: OutlineInputBorder(),
                helperText: 'Secret for second identity',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _initializeIdentities,
                icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.person_add),
                label: const Text('Initialize Identities'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProofSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proof Generation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
                helperText: 'Message to sign with the proof',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _scopeController,
              decoration: const InputDecoration(
                labelText: 'Scope',
                border: OutlineInputBorder(),
                helperText: 'Scope for the proof',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isLoading || _identity1 == null) ? null : _generateProof,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.security),
                    label: const Text('Generate Proof'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: (_isLoading || !_hasGeneratedProof) ? null : _verifyProof,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified),
                    label: const Text('Verify Proof'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hasGeneratedProof ? Colors.green : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Results',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _status,
                style: const TextStyle(fontSize: 14, fontFamily: 'monospace'),
              ),
            ),
            if (_hasGeneratedProof) ...[
              const SizedBox(height: 16),
              const Text(
                'Generated Proof:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Text(
                  _generatedProof.length > 100 
                      ? '${_generatedProof.substring(0, 100)}...'
                      : _generatedProof,
                  style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                ),
              ),
            ],
            if (_hasGeneratedProof) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    _proofVerificationResult ? Icons.check_circle : Icons.cancel,
                    color: _proofVerificationResult ? Colors.green : Colors.red,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Verification: ${_proofVerificationResult ? "SUCCESS" : "PENDING"}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _proofVerificationResult ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semaphore Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        cardTheme: const CardTheme(
          elevation: 2,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Semaphore Flutter Demo'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildInputSection(),
              _buildProofSection(),
              _buildResultSection(),
            ],
          ),
        ),
      ),
    );
  }
}
