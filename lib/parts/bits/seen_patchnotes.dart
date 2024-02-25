import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class SeenPatchNotesModal extends ChangeNotifier {
  bool _seenPatches = UserTelemetry().currentModel.seenPatchNotes;

  bool get seenPatches => _seenPatches;

  set seenPatches(bool v) {
    Debug().info("Has Seen patch notes: $_seenPatches -> $v");
    _seenPatches = v;
    UserTelemetry().currentModel.seenPatchNotes = v;
    UserTelemetry().save();
    notifyListeners();
  }

  static bool hasSeenPatchNotes(BuildContext context) =>
      Provider.of<SeenPatchNotesModal>(context)._seenPatches;
}
