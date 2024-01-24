import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/parts/views/console.dart';
import 'package:scouting_app_2024/shared.dart';

class DebugObserver extends BlocObserver {
  const DebugObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    Debug().info(
        "STATE_BASE: ${bloc.runtimeType} -> $change for ${change.currentState.runtimeType}");
  }
}

class Debug {
  Debug._();
  factory Debug() => _singleton;
  static final Debug _singleton = Debug._();
  final Logger _logger = Logger("RebelRobotic2024");
  bool useStdIO = true;
  String Function(LogRecord record) stdIOPrettifier = (LogRecord
          record) =>
      "${record.time} | ${stringClampFromRight(record.level.name, 4)}\t>>\t${record.message}";

  void init() {
    if (useStdIO) {
      listen((LogRecord record) => print(
          "${record.time} | ${record.level} >> ${record.message}"));
    }
    // this makes sure we capture all of the data before the app runs or any states that are not yet initted.
    // thus make sure to call init before the app itself starts!!
    listen((LogRecord record) {
      if (ConsoleStateComponent.internalConsoleBuffer.length >=
          Shared.MAX_LOG_LENGTH) {
        ConsoleStateComponent.internalConsoleBuffer.clear();
      }
      ConsoleStateComponent.internalConsoleBuffer
          .add(stdIOPrettifier.call(record));
    });
  }

  void listen(void Function(LogRecord record) listener) =>
      _logger.onRecord.asBroadcastStream().listen(listener);
  void fine(dynamic msg) => _logger.fine(msg);
  void warn(dynamic msg) => _logger.warning(msg);
  void info(dynamic msg) => _logger.info(msg);
}
