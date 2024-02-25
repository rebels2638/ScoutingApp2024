import 'package:flutter/material.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/parts/bits/prefer_canonical.dart';
import 'package:scouting_app_2024/parts/bits/use_alt_layout.dart';
import 'package:scouting_app_2024/user/models/team_model.dart';

class TeamAllianceSwitch extends StatefulWidget {
  final void Function(TeamAlliance alliance) onChanged;
  final bool initialValue;

  const TeamAllianceSwitch({
    super.key,
    required this.onChanged,
    this.initialValue = false, // false = red, true = blue
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
      mainAxisAlignment:
          UseAlternativeLayoutModal.isAlternativeLayoutPreferred(
                  context)
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        AnimatedSwitcher(
          transitionBuilder:
              (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, -1),
                      end: const Offset(0, 0))
                  .animate(animation),
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          child: !_toggled
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color:
                          PreferCanonicalModal.isCanonicalPreferred(
                                  context)
                              ? TeamAlliance.red.toColor()
                              : null),
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
        const SizedBox(width: 12),
        RepaintBoundary(
          child: Tooltip(
            message: "${_toggled ? "Blue" : "Red"} Alliance",
            child: Switch(
              value: _toggled,
              trackColor:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) =>
                              states.contains(MaterialState.selected)
                                  ? TeamAlliance.blue
                                      .toColor()
                                      .withAlpha(0x80)
                                  : TeamAlliance.red
                                      .toColor()
                                      .withAlpha(0x80))
                      : null,
              thumbColor:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) =>
                              states.contains(MaterialState.selected)
                                  ? TeamAlliance.blue.toColor()
                                  : TeamAlliance.red.toColor())
                      : null,
              overlayColor:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) => states
                                  .contains(MaterialState.selected)
                              ? TeamAlliance.blue
                                  .toColor()
                                  .withOpacity(0.42)
                              : TeamAlliance.red
                                  .toColor()
                                  .withOpacity(0.42))
                      : null,
              trackOutlineColor:
                  PreferCanonicalModal.isCanonicalPreferred(context)
                      ? MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) =>
                              states.contains(MaterialState.selected)
                                  ? TeamAlliance.blue
                                      .toColor()
                                      .addAll(200)
                                  : TeamAlliance.red
                                      .toColor()
                                      .addAll(200))
                      : null,
              onChanged: (bool e) {
                setState(() => _toggled = !_toggled);
                widget.onChanged
                    .call(e ? TeamAlliance.blue : TeamAlliance.red);
              },
            ),
          ),
        ),
        const SizedBox(width: 12),
        AnimatedSwitcher(
          transitionBuilder:
              (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: const Offset(0, 0))
                  .animate(animation),
              child: child,
            );
          },
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          child: _toggled
              ? Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color:
                          PreferCanonicalModal.isCanonicalPreferred(
                                  context)
                              ? TeamAlliance.blue.toColor()
                              : null),
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
