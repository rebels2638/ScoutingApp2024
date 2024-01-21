import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/user/team_model.dart';

class TeamAllianceSwitch extends StatefulWidget {
  final void Function(TeamAlliance alliance) onChanged;
  final bool initialValue;

  const TeamAllianceSwitch({
    super.key,
    required this.onChanged,
    this.initialValue = false,
  });

  @override
  State<TeamAllianceSwitch> createState() =>
      _TeamAllianceSwitchState();
}

class _TeamAllianceSwitchState extends State<TeamAllianceSwitch> {
  late bool _toggled;

  @override
  void initState() {
    super.initState();
    _toggled = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          child: !_toggled
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: TeamAlliance.red.toColor()),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 2, bottom: 2, left: 3, right: 3),
                    child: Text("Red",
                        style:
                            TextStyle(fontWeight: FontWeight.w500)),
                  ))
              : const Padding(
                  padding: EdgeInsets.only(
                      top: 2, bottom: 2, left: 3, right: 3),
                  child: Text("Red",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
        ),
        strut(width: 12),
        RepaintBoundary(
          child: Tooltip(
            message: "${_toggled ? "Blue" : "Red"} Alliance",
            child: Switch(
              value: _toggled,
              trackColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => states
                          .contains(MaterialState.selected)
                      ? TeamAlliance.blue.toColor().withAlpha(0x80)
                      : TeamAlliance.red.toColor().withAlpha(0x80)),
              thumbColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                return states.contains(MaterialState.selected)
                    ? TeamAlliance.blue.toColor()
                    : TeamAlliance.red.toColor();
              }),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => states
                          .contains(MaterialState.selected)
                      ? TeamAlliance.blue.toColor().withOpacity(0.42)
                      : TeamAlliance.red.toColor().withOpacity(0.42)),
              trackOutlineColor:
                  MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) => states
                              .contains(MaterialState.selected)
                          ? TeamAlliance.blue.toColor().addAll(200)
                          : TeamAlliance.red.toColor().addAll(200)),
              onChanged: (bool e) {
                setState(() => _toggled = !_toggled);
                widget.onChanged
                    .call(e ? TeamAlliance.blue : TeamAlliance.red);
              },
            ),
          ),
        ),
        strut(width: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          child: _toggled
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: TeamAlliance.blue.toColor()),
                  child: const Padding(
                    padding: EdgeInsets.only(
                        top: 2, bottom: 2, left: 3, right: 3),
                    child: Text("Blue",
                        style:
                            TextStyle(fontWeight: FontWeight.w500)),
                  ))
              : const Padding(
                  padding: EdgeInsets.only(
                      top: 2, bottom: 2, left: 3, right: 3),
                  child: Text("Blue",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
        ),
      ],
    );
  }
}
