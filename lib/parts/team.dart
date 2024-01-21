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
        AnimatedContainer(
          duration: const Duration(seconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: !_toggled
                  ? TeamAlliance.red.toColor()
                  : Colors.transparent),
          child: const Padding(
            padding:
                EdgeInsets.only(top: 2, bottom: 2, left: 3, right: 3),
            child: Text("Red"),
          ),
        ),
        strut(width: 12),
        Tooltip(
          message: "${_toggled ? "Blue" : "Red"} Alliance",
          child: Switch(
            value: _toggled,
            trackColor: MaterialStateProperty.resolveWith<
                Color?>((Set<MaterialState> states) => states
                    .contains(MaterialState.selected)
                // see: https://github.com/flutter/flutter/blob/954d30f07f018ec2943212a907a3c1c520e5bec4/packages/flutter/lib/src/material/switch.dart#L353
                ? TeamAlliance.blue.toColor().withAlpha(0x80)
                : TeamAlliance.red.toColor().withAlpha(0x80)),
            thumbColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              return states.contains(MaterialState
                      .selected) // this took me so long to debug for some reason and i just realized i forgor to put an alpha value in TeamAlliance.red lmao
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
                    (Set<MaterialState> states) =>
                        states.contains(MaterialState.selected)
                            ? TeamAlliance.blue.toColor().addAll(200)
                            : TeamAlliance.red.toColor().addAll(200)),
            onChanged: (bool e) {
              setState(() => _toggled = !_toggled);
              widget.onChanged
                  .call(e ? TeamAlliance.blue : TeamAlliance.red);
            },
          ),
        ),
        strut(width: 12),
        if (_toggled)
          AnimatedContainer(
            duration: const Duration(
                milliseconds: 500), // Set your desired duration
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
                color: _toggled
                    ? TeamAlliance.blue.toColor()
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(2)),
            child: const Padding(
              padding: EdgeInsets.only(
                  top: 2, bottom: 2, left: 3, right: 3),
              child: Text("Blue"),
            ),
          )
        else
          const Padding(
            padding:
                EdgeInsets.only(top: 2, bottom: 2, left: 3, right: 3),
            child: Text("Blue"),
          ),
      ],
    );
  }
}
