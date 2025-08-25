import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'logs.dart';

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
      appBar: AppBar(title: Text('API Test')),
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
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _endpointController,
                    decoration: InputDecoration(labelText: 'Endpoint (e.g. /users)'),
                  ),
                ),
              ],
            ),
            if (_method != 'GET') ...[
              SizedBox(height: 8),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(labelText: 'Request Body (JSON)'),
                minLines: 2,
                maxLines: 5,
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _sendRequest,
              child: Text('Send'),
            ),
            SizedBox(height: 16),
            Text('Response:'),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  color: Colors.grey[200],
                  padding: EdgeInsets.all(8),
                  child: Text(_response ?? '', style: TextStyle(fontFamily: 'monospace')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendRequest() async {
    setState(() {
      _loading = true;
      _response = null;
    });
    final url = Uri.parse(apiBaseUrl + _endpointController.text.trim());
    http.Response resp;
    await traceInfo('ApiTest', 'Sending $_method request to ${url.toString()}');
    try {
      switch (_method) {
        case 'GET':
          resp = await http.get(url);
          break;
        case 'POST':
          resp = await http.post(url, body: _bodyController.text, headers: {'Content-Type': 'application/json'});
          break;
        case 'PUT':
          resp = await http.put(url, body: _bodyController.text, headers: {'Content-Type': 'application/json'});
          break;
        case 'DELETE':
          resp = await http.delete(url);
          break;
        default:
          resp = http.Response('Unsupported method', 400);
      }
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