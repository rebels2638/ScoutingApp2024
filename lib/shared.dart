import 'dart:io';

import 'package:uuid/uuid.dart';

class Shared {
  static const int MAX_LOG_LENGTH = 718;
  static const int PERIODIC_LOGGING_REFRESH =
      1500; // every 1,5 seconds

  static const String FONT_FAMILY_SANS = "IBM Plex Sans";
  static const Uuid uuid = Uuid();
  static const String DEVICE_STORAGE_SUBDIR = "RebelsScoutingApp";
  static const bool PREFER_DOCS_DIR =
      true; // if false, then we use DeviceEnv.cachePath
  static const int HAZARD_PHASE_DIAMOND_REPS = 20;
  static const int USER_USAGE_TIME_PROBE_PERIODIC = 30; //seconds
  static const bool SAVE_ON_PROBE = false;
  static const int USER_TELEMETRY_SAVE_CYCLE = 50; // seconds
  static const String GENERAL_TIME_FORMAT = "HH:mm MM/dd/yyyy";
  static const double QR_CODE_SIZE = 648;
  static const int DUC_SAVE_PERIOD = 45; //seconds
}

final String TELEMETRY_SUBDIR_PATH =
    "$APP_CANONICAL_NAME${Platform.pathSeparator}";
const String APP_CANONICAL_NAME = "Argus"; // be goofy with this :)
const String REBEL_ROBOTICS_APP_VERSION =
    "1.0.8"; // [0].[1].[2] for version format
const String REBEL_ROBOTICS_APP_NAME =
    "2638 Scouting \"$APP_CANONICAL_NAME\"";
const String REBEL_ROBOTICS_APP_LEGALESE =
    "Copyright (c) 2024, Jack Meng (exoad). All rights reserved.";
const String REBEL_ROBOTICS_APP_GITHUB_REPO_URL =
    "https://github.com/rebels2638/ScoutingApp2024";
const String REBEL_ROBOTICS_APP_TUTORIAL_VIDEO_URL =
    "https://www.youtube.com/watch?v=-5jyO0sAhnA";
