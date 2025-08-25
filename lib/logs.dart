import 'package:myapp/config.dart';

Future<void> traceInfo(String id, String content) async {
  print('info log: $id, $content');
}

Future<void> traceError(String id, String content) async {
  print('error log: $id, $content');
}

Future<void> traceWarning(String id, String content) async {
  print('warning log: $id, $content');
}
