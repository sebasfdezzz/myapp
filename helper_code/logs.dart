import 'package:myapp/config.dart';
import 'package:myapp/controllers/api.dart';
import 'package:myapp/controllers/global_data.dart';

Future<void> traceInfo(String id, String content) async {
  print('info log: $id, $content');
  if (Config.logErrorsOnly) return;
  GlobalData.logSession.trace('info', id, content);
  if (Config.enableLogging && Config.continuousLogging) {
    bool success = await LogsAPI.postLog(GlobalData.logSession.toJsonEncoded());
    if (!success) {
      print('Error sending info log: $id, $content');
    }
  }
}

Future<void> traceError(String id, String content) async {
  print('error log: $id, $content');
  GlobalData.logSession.trace('error', id, content);
  if (Config.enableLogging && Config.continuousLogging) {
    bool success = await LogsAPI.postLog(GlobalData.logSession.toJsonEncoded());
    if (!success) {
      print('Error sending error log: $id, $content');
    }
  }
}

Future<void> traceWarning(String id, String content) async {
  print('warning log: $id, $content');
  if (Config.logErrorsOnly) return;
  GlobalData.logSession.trace('warning', id, content);
  if (Config.enableLogging && Config.continuousLogging) {
    bool success = await LogsAPI.postLog(GlobalData.logSession.toJsonEncoded());
    if (!success) {
      print('Error sending warning log: $id, $content');
    }
  }
}
