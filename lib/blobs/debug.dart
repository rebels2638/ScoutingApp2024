import 'dart:async';

import 'package:logging/logging.dart';

class Debug {
  static final StreamController<LogRecord> _logStream =
      StreamController<LogRecord>.broadcast();
  static final Logger _logger = Logger("RebelRobotic2024");
  static bool useStdIO = true;
  static String Function(LogRecord record) stdIOPrettifier =
      (LogRecord record) =>
          "${record.time} | ${record.level}\t>>\t${record.message}";

  void init() {
    _logger.level = Level.ALL;
    if (useStdIO) {
      _logger.onRecord
          .listen((LogRecord v) => print(stdIOPrettifier.call(v)));
    }
  }

  void listen(void Function(LogRecord record) listener) =>
      _logStream.(listener);
  void setLogLevel(Level level) => _logger.level = level;
  void fine(dynamic msg) => _logger.fine(msg);
  void warn(dynamic msg) => _logger.warning(msg);
  void info(dynamic msg) => _logger.info(msg);
}
