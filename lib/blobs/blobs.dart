import "package:flutter/material.dart";
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:scouting_app_2024/debug.dart';

enum SwitchIconPosition {
  /// the icon will be placed on the thumb
  onSwitch,

  /// the icon will be placed around the switch using a row
  aroundSwitch
}

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

class _BasicToggleSwitchState extends State<BasicToggleSwitch> {
  late bool _toggleState;

  @override
  void initState() {
    super.initState();
    _toggleState = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
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
}

/// creates a strut, aka a sizedbox
@pragma("vm:prefer-inline")
Widget strut({double? width, double? height}) =>
    SizedBox(width: width, height: height);

@pragma("vm:prefer-inline")
Widget roundPadContainer(
        {required Widget child,
        required double factor,
        Color? color,
        Gradient? gradient,
        List<BoxShadow>? boxShadow}) =>
    Padding(
        padding: EdgeInsets.all(factor),
        child: Container(
            decoration: BoxDecoration(
                color: color,
                gradient: gradient,
                boxShadow: boxShadow,
                borderRadius: BorderRadius.circular(factor)),
            child: child));

@pragma("vm:prefer-inline")
Widget svgIcon(String url) => SvgIcon(icon: SvgIconData(url));

@pragma("vm:prefer-inline")
List<Widget> strutAll(List<Widget> children,
    {double? width, double? height}) {
  List<Widget> result = <Widget>[];
  for (int i = 0; i < children.length; i++) {
    result.add(children[i]);
    if (i < children.length - 1) {
      result.add(strut(width: width, height: height));
    }
  }
  return result;
}

/// generic confirmation dialog
@pragma("vm:prefer-inline")
Future<void> launchConfirmDialog(BuildContext context,
    {required Widget message,
    Icon? icon,
    String title = "Are you sure?",
    bool showOkLabel = true,
    String okLabel = "Yes",
    String denyLabel = "No",
    required void Function() onConfirm,
    void Function()? onDeny}) async {
  Debug().info(
      "Launched a CONFIRM_DIALOG with ${message.hashCode}"); // we use the provided context
  await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              icon: icon ?? const Icon(Icons.warning_amber_rounded),
              title: Text(title),
              content: message,
              actions: <Widget>[
                if (showOkLabel)
                  TextButton.icon(
                    icon: const Icon(Icons.check_rounded),
                    label: Text(okLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700)),
                    onPressed: () {
                      onConfirm.call();
                      Navigator.of(context).pop();
                      Debug().info(
                          "CONFIRM_DIALOG ${message.hashCode} ended with CONFIRM");
                    },
                  ),
                TextButton.icon(
                  icon: const Icon(Icons.not_interested_rounded),
                  label: Text(denyLabel,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700)),
                  onPressed: () {
                    onDeny?.call();
                    Navigator.of(context).pop();
                    Debug().info(
                        "CONFIRM_DIALOG ${message.key} ended with DENY");
                  },
                )
              ]));
}
