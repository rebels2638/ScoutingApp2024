import 'package:flutter/material.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class PatchNotesDisplay extends StatelessWidget {
  final Map<String, dynamic> patchNotes;

  const PatchNotesDisplay(this.patchNotes, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserTelemetry().currentModel.seenPatchNotes) {
      UserTelemetry().currentModel.seenPatchNotes = true;
      UserTelemetry().save();
    }
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics()),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Text.rich(
                TextSpan(children: <InlineSpan>[
                  const TextSpan(
                      text: "Patch Notes\n",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24)),
                  TextSpan(
                      text: "\nVersion: ${patchNotes["version"]}"),
                  TextSpan(text: "\nDate: ${patchNotes["date"]}"),
                  TextSpan(text: "\nBy: ${patchNotes["author"]}\n\n"),
                  const WidgetSpan(
                      child: Icon(Icons.new_releases_rounded)),
                  TextSpan(
                      text: " Additions",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                      children: <InlineSpan>[
                        for (String r in patchNotes["additions"])
                          TextSpan(
                              text: "\n",
                              children: <InlineSpan>[
                                const TextSpan(
                                    text: "+",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                TextSpan(text: " $r")
                              ],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                      ]),
                  const TextSpan(text: "\n"),
                  const WidgetSpan(child: Divider()),
                  const TextSpan(text: "\n"),
                  const WidgetSpan(
                      child: Icon(Icons.auto_fix_high_rounded)),
                  TextSpan(
                      text: " Fixes",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                      children: <InlineSpan>[
                        for (String r in patchNotes["fixes"])
                          TextSpan(
                              text: "\n",
                              children: <InlineSpan>[
                                const TextSpan(
                                    text: "-",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                TextSpan(text: " $r")
                              ],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                      ]),
                  const TextSpan(text: "\n"),
                  const WidgetSpan(child: Divider()),
                  const TextSpan(text: "\n"),
                  const WidgetSpan(
                      child: Icon(Icons.bug_report_rounded)),
                  TextSpan(
                      text: " Optimizations",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22),
                      children: <InlineSpan>[
                        for (String r in patchNotes["optimize"])
                          TextSpan(
                              text: "\n",
                              children: <InlineSpan>[
                                const TextSpan(
                                    text: "~",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16)),
                                TextSpan(text: " $r")
                              ],
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal))
                      ]),
                ]),
                style: const TextStyle(fontFamily: "Monospace")),
          ),
          const SizedBox(height: 10),
          const Text("Thank you for using the app! :)"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
