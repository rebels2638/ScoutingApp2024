import 'package:logging/logging.dart';

class Debug {
  Debug._();
  factory Debug() => _singleton;
  static final Debug _singleton = Debug._();
  final Logger _logger = Logger("RebelRobotic2024");
  bool useStdIO = true;
  String Function(LogRecord record) stdIOPrettifier =
      (LogRecord record) =>
          "${record.time} | ${record.level}\t>>\t${record.message}";

  void init() {
    if (useStdIO) {
      listen((LogRecord record) => print(
          "${record.time} | ${record.level} >> ${record.message}"));
    }
  }

  void listen(void Function(LogRecord record) listener) =>
      _logger.onRecord.asBroadcastStream().listen(listener);
  void setLogLevel(Level level) => _logger.level = level;
  void fine(dynamic msg) => _logger.fine(msg);
  void warn(dynamic msg) => _logger.warning(msg);
  void info(dynamic msg) => _logger.info(msg);
}
