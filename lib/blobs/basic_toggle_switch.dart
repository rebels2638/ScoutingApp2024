import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';

import 'switch_icon_position.dart';

class BasicToggleSwitch extends StatefulWidget {
  final void Function(bool res) onChanged;
  final bool initialValue;
  final Icon? offIcon;
  final Icon? onIcon;
  final SwitchIconPosition position;

  const BasicToggleSwitch(
      {super.key,
      required this.onChanged,
      this.initialValue = false,
      this.position = SwitchIconPosition.onSwitch,
      this.offIcon = const Icon(Icons.close_rounded),
      this.onIcon = const Icon(Icons.check_rounded)});

  @override
  State<BasicToggleSwitch> createState() => _BasicToggleSwitchState();
}

class _BasicToggleSwitchState extends State<BasicToggleSwitch>
    with AutomaticKeepAliveClientMixin {
  late bool _toggleState;

  @override
  void initState() {
    super.initState();
    _toggleState = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.onIcon != null &&
            widget.offIcon != null &&
            widget.position == SwitchIconPosition.aroundSwitch
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: strutAll(<Widget>[
              widget.offIcon!,
              Switch(
                  value: _toggleState,
                  onChanged: (bool result) {
                    setState(() => _toggleState = !_toggleState);
                    widget.onChanged.call(result);
                  }),
              widget.onIcon!,
            ], width: 8))
        : widget.position == SwitchIconPosition.onSwitch
            ? Switch(
                thumbIcon: MaterialStateProperty.resolveWith(
                    (Set<MaterialState> states) =>
                        states.contains(MaterialState.selected)
                            ? widget.onIcon
                            : widget.offIcon),
                value: _toggleState,
                onChanged: (bool result) {
                  setState(() => _toggleState = !_toggleState);
                  widget.onChanged.call(result);
                })
            : Switch(
                value: _toggleState,
                onChanged: (bool result) {
                  setState(() => _toggleState = !_toggleState);
                  widget.onChanged.call(result);
                });
  }

  @override
  bool get wantKeepAlive => true;
}
