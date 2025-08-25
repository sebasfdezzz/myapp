import 'dart:convert';

import 'package:myapp/controllers/global_data.dart';
import 'package:myapp/controllers/logs.dart';
import 'package:uuid/uuid.dart';

class Log {
  final String uuid;
  String userId;
  String userEmail;
  final String startSession;
  final List<String> info;
  final List<String> warning;
  final List<String> error;

  Log({
    required this.uuid,
    required this.userId,
    required this.userEmail,
    required this.startSession,
    required this.info,
    required this.warning,
    required this.error,
  });

  factory Log.create({String userId = '', String userEmail = 'unknown'}) {
    final now = DateTime.now().toUtc();
    return Log(
      uuid: const Uuid().v4(),
      userId: userId,
      userEmail: userEmail,
      startSession: now.toIso8601String(),
      info: [],
      warning: [],
      error: [],
    );
  }

  void updateUser() {
    userId = GlobalData.userInfo.userId ?? 'unknown';
    userEmail = GlobalData.userInfo.email ?? 'unknown';
  }

  bool trace(String type, String id, String content) {
    switch (type) {
      case 'info':
        info.add('$id: $content');
        return true;
      case 'warning':
        warning.add('$id: $content');
        return true;
      case 'error':
        error.add('$id: $content');
        return true;
    }
    return false;
  }

  static Log? fromJson(Map<String, dynamic> json) {
    try {
      return Log(
        uuid: json['uuid'] as String,
        userId: json['user_id'] as String,
        userEmail: json['user_email'] as String,
        startSession: json['start_session'] as String,
        info: List<String>.from(json['info'] ?? []),
        warning: List<String>.from(json['warning'] ?? []),
        error: List<String>.from(json['error'] ?? []),
      );
    } catch (error) {
      traceError('default', 'Error parsing Lesson from JSON: $error');
      traceError('default', 'Offending JSON: $json');
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'user_id': userId,
      'user_email': userEmail,
      'start_session': startSession,
      'info': info,
      'warning': warning,
      'error': error,
    };
  }

  String toJsonEncoded() {
    return json.encode({
      'uuid': uuid,
      'user_id': userId,
      'user_email': userEmail,
      'start_session': startSession,
      'info': info,
      'warning': warning,
      'error': error,
    });
  }

  @override
  String toString() {
    return 'Log(uuid: $uuid, userId: $userId, userEmail: $userEmail, startSession: $startSession, info: $info, warning: $warning, error: $error)';
  }

  Log copyWith(
      {List<String>? info, List<String>? warning, List<String>? error}) {
    return Log(
        uuid: uuid,
        userId: userId,
        userEmail: userEmail,
        startSession: startSession,
        info: info ?? this.info,
        warning: warning ?? this.warning,
        error: error ?? this.error);
  }
}
