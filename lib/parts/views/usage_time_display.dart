import 'package:flutter/material.dart';
import 'package:scouting_app_2024/extern/datetime.dart';
import 'package:scouting_app_2024/main.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class UsageTimeDisplay extends StatelessWidget {
  const UsageTimeDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double currSess =
        (DateTime.now() - APP_START_TIME).millisecondsSinceEpoch *
            0.001 /
            3600;
    return Column(
      children: <Widget>[
        Tooltip(
          message:
              "${UserTelemetry().currentModel.usedTimeHours} hours",
          child: Text.rich(TextSpan(children: <InlineSpan>[
            const WidgetSpan(
                child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.timeline_rounded, size: 18),
            )),
            const TextSpan(
                text: "Usage Time:",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            TextSpan(
                text:
                    " ${UserTelemetry().currentModel.usedTimeHours.toStringAsFixed(2)} hours",
                style: const TextStyle(fontSize: 18)),
          ])),
        ),
        const SizedBox(height: 10),
        Tooltip(
          message: "${currSess.toStringAsFixed(5)} hours",
          child: Text.rich(TextSpan(children: <InlineSpan>[
            const TextSpan(
                text: "Current Session: ",
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            TextSpan(
                text: "${currSess.toStringAsFixed(2)} hours",
                style: const TextStyle(fontSize: 14)),
          ])),
        ),
      ],
    );
  }
}
