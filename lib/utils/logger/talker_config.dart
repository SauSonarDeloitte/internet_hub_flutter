import 'package:talker_flutter/talker_flutter.dart';

class TalkerConfig {
  static Talker? _instance;
  
  static Talker get instance {
    _instance ??= TalkerFlutter.init(
      settings: TalkerSettings(
        useConsoleLogs: true,
        useHistory: true,
        maxHistoryItems: 500,
      ),
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(
          enableColors: true,
          lineSymbol: '│',
        ),
      ),
    );
    return _instance!;
  }
  
  static void log(String message, {String? tag}) {
    instance.log(message, logLevel: LogLevel.info);
  }
  
  static void error(dynamic error, [StackTrace? stackTrace]) {
    instance.error(error, stackTrace);
  }
  
  static void warning(String message) {
    instance.warning(message);
  }
  
  static void debug(String message) {
    instance.debug(message);
  }
  
  static void info(String message) {
    instance.info(message);
  }
}
