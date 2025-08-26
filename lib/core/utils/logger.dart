import 'dart:developer' as developer;

class Logger {
  static const String _name = 'FlutterApp';

  static void d(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 500, // DEBUG
    );
  }

  static void i(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 800, // INFO
    );
  }

  static void w(String message, [String? tag]) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 900, // WARNING
    );
  }

  static void e(String message, [String? tag, Object? error]) {
    developer.log(
      message,
      name: tag ?? _name,
      level: 1000, // ERROR
      error: error,
    );
  }
}
