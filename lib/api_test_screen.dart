import 'package:flutter/material.dart';
import 'config.dart';
import 'logs.dart';
import 'api.dart';

class ApiTestScreen extends StatefulWidget {
  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  String _method = 'GET';
  final _endpointController = TextEditingController();
  final _bodyController = TextEditingController();
  String? _response;
  bool _loading = false;

  @override
  void dispose() {
    _endpointController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('API Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                DropdownButton<String>(
                  value: _method,
                  items: ['GET', 'POST', 'PUT', 'DELETE']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _endpointController,
                    decoration: const InputDecoration(labelText: 'Endpoint (e.g. /users)'),
                  ),
                ),
              ],
            ),
            if (_method != 'GET') ...[
              const SizedBox(height: 8),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Request Body (JSON)'),
                minLines: 2,
                maxLines: 5,
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _sendRequest,
              child: const Text('Send'),
            ),
            const SizedBox(height: 16),
            const Text('Response:'),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  padding: const EdgeInsets.all(8),
                  child: Text(_response ?? '', style: const TextStyle(fontFamily: 'monospace')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendRequest() async {
    setState(() {
      _loading = true;
      _response = null;
    });

    final url = Uri.parse(Config.apiBaseUrl + _endpointController.text.trim());

    try {
      await traceInfo('ApiTest', 'Sending $_method request to $url');
      final resp = await Api.callApi(
        method: _method,
        url: url,
        body: _method == 'GET' ? null : _bodyController.text.trim(),
      );

      await traceInfo('ApiTest', 'Response ${resp.statusCode}: ${resp.body}');
      setState(() {
        _response = 'Status: ${resp.statusCode}\n${resp.body}';
      });
    } catch (e) {
      await traceError('ApiTest', 'Request failed: $e');
      setState(() {
        _response = 'Error: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}
