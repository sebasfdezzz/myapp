import 'package:flutter/material.dart';
import 'api.dart'; // Assuming api.dart is in the same directory

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({super.key});

  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final TextEditingController _endpointController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  @override
  void dispose() {
    _endpointController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  void _callApi() {
    final String endpoint = _endpointController.text;
    final String body = _bodyController.text;
    final List<dynamic> apiData = [endpoint, body];

    Api().call_api(apiData);

    // You might want to add some visual feedback here, like a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API called!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Test Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'Endpoint',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              maxLines: null, // Makes the text field multiline
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _callApi,
              child: const Text('Call API'),
            ),
          ],
        ),
      ),
    );
  }
}