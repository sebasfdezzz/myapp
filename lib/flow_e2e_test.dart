import 'package:flutter/material.dart';

class E2EScreen extends StatefulWidget {
  @override
  _E2EScreenState createState() => _E2EScreenState();
}

class _E2EScreenState extends State<E2EScreen> {
  String _statusMessage = "";

  void _runTest() {
    try {
      bool result = E2ETest.startTest();
      setState(() {
        _statusMessage = result ? "Test completed successfully" : "Test failed";
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _runTest,
              child: const Text("Start Test"),
            ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class E2ETest {
  static bool startTest() {
    try {

      return true;
    } catch (e) {
      throw e;
    }
  }
}
