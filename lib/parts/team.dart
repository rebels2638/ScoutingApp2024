import 'package:flutter/material.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:scouting_app_2024/user/team_model.dart';

class TeamAllianceSwitch extends StatefulWidget {
  final void Function(TeamAlliance alliance) onChanged;
  final bool initialValue;

  const TeamAllianceSwitch(
      {super.key,
      required this.onChanged,
      this.initialValue = false});

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
    return Switch(
      value: _toggled,
      trackColor: MaterialStateProperty.resolveWith<
          Color?>((Set<MaterialState> states) => states
              .contains(MaterialState.selected)
          // see: https://github.com/flutter/flutter/blob/954d30f07f018ec2943212a907a3c1c520e5bec4/packages/flutter/lib/src/material/switch.dart#L353
          ? TeamAlliance.blue.toColor().withAlpha(0x80)
          : TeamAlliance.red.toColor().withAlpha(0x80)),
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) =>
              states.contains(MaterialState.selected)
                  ? TeamAlliance.blue.toColor()
                  : TeamAlliance.red.toColor()),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) =>
              states.contains(MaterialState.selected)
                  ? TeamAlliance.blue.toColor().withOpacity(0.42)
                  : TeamAlliance.red.toColor().withOpacity(0.42)),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) =>
              states.contains(MaterialState.selected)
                  ? TeamAlliance.blue.toColor().addAll(50)
                  : TeamAlliance.red.toColor().addAll(50)),
      onChanged: (bool e) {
        setState(() => _toggled = e);
        widget.onChanged
            .call(e ? TeamAlliance.blue : TeamAlliance.red);
      },
    );
  }
}
