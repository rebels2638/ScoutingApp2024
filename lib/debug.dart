import 'dart:async';

import 'package:logging/logging.dart';
import 'package:scouting_app_2024/blobs/locale_blob.dart';
import 'package:scouting_app_2024/parts/views/console.dart';
import 'package:scouting_app_2024/shared.dart';
import 'package:scouting_app_2024/utils.dart';

class Debug {
  @pragma("vm:prefer-inline")
  static bool isPhase(LogRecord record) =>
      record.message.contains(GenericUtils.HAZARD_DIAMOND);
  Debug._();
  String _lastPhase = "Init";
  factory Debug() => _singleton;
  static final Debug _singleton = Debug._();
  late final Logger _logger;
  bool useStdIO = true;

  void newPhase(String phaseName) {
    final String diamonds = GenericUtils.repeatStr(
        GenericUtils.HAZARD_DIAMOND,
        Shared.HAZARD_PHASE_DIAMOND_REPS);
    _logger
        .info("\n$diamonds  [ $_lastPhase->$phaseName ]  $diamonds");
    _lastPhase = phaseName;
  }

  String Function(LogRecord record) stdIOPrettifier = (LogRecord
          record) =>
      "${record.time} | ${stringClampFromRight(record.level.name, 4)}\t>>\t${record.message}";

  void init() {
    _logger = Logger("Argus2638");
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

  StreamSubscription<LogRecord> listen(
          void Function(LogRecord record) listener) =>
      _logger.onRecord.asBroadcastStream().listen(listener);
  void warn(dynamic msg) => _logger.warning(msg);
  void ohno(dynamic msg) => _logger.severe(msg);
  void info(dynamic msg) => _logger.info(msg);
}
