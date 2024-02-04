import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/parts/bits/show_console.dart';
import 'package:scouting_app_2024/parts/views_delegate.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

class SettingsView extends StatelessWidget
    implements AppPageViewExporter {
  const SettingsView({super.key});

  @pragma("vm:prefer-inline")
  static Widget _labelIt(
          {IconData? icon,
          required String label,
          String? hint,
          required Widget child}) =>
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(children: <Widget>[
                if (icon != null) Icon(icon, size: 48),
                strut(width: 22),
                if (hint == null)
                  Text(label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold))
                else
                  Text.rich(TextSpan(children: <InlineSpan>[
                    TextSpan(
                        text: "$label\n",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: hint,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ))
                  ]))
              ]),
              child
            ]),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: strutAll(<Widget>[
            _labelIt(
                icon: Icons.terminal_rounded,
                label: "Show Development Console",
                hint: "A page for debug and development purposes",
                child: BasicToggleSwitch(
                    initialValue: UserTelemetry()
                        .currentModel
                        .showConsole, // i feel like we could somehow combine it with the preceding Provider.of because both are going to traverse the tree anyways
                    onChanged: (bool val) {
                      Provider.of<ShowConsoleModal>(context,
                              listen: false)
                          .showingConsole = val;
                      UserTelemetry().currentModel.showConsole = val;
                      UserTelemetry().save();
                    }))
          ])),
    );
  }

  @override
  ({
    Widget child,
    ({Icon activeIcon, Icon icon, String label, String tooltip}) item
  }) exportAppPageView() {
    return (
      child: this,
      item: (
        activeIcon: const Icon(Icons.settings_applications_rounded),
        icon: const Icon(Icons.settings_applications_outlined),
        label: "Settings",
        tooltip: "Configure preferences for the application"
      )
    );
  }
}
