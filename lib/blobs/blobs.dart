import "package:flutter/material.dart";
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/user/user_telemetry.dart';

enum SwitchIconPosition {
  /// the icon will be placed on the thumb
  onSwitch,

  /// the icon will be placed around the switch using a row
  aroundSwitch
}

@pragma("vm:prefer-inline")
Widget material3ExtFabLook(
        {required void Function() onTap,
        Color? color,
        required Widget child}) =>
    GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: color),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      ),
    );

// there is no much boilerplate shitty code for this number picker thing, just look below, there are like 2 delegate functions for this lmfao
class _InternalNumberPicker extends StatefulWidget {
  final int maxValue;
  final int minValue;
  final int itemCount;
  final bool infiniteLoop;
  final Axis? alignment;
  final void Function(int res) onChange;

  const _InternalNumberPicker(
      {required this.onChange,
      required this.maxValue,
      required this.minValue,
      required this.itemCount,
      required this.infiniteLoop,
      required this.alignment});

  @override
  State<_InternalNumberPicker> createState() =>
      _InternalNumberPickerState();
}

class _InternalNumberPickerState
    extends State<_InternalNumberPicker> {
  late List<int> _valueCounts;

  @override
  void initState() {
    super.initState();
    assert(
        widget.itemCount == widget.maxValue.abs().toString().length,
        "Item count must match the supplied max length!");
    _valueCounts = List<int>.generate(
        widget.itemCount, (int index) => widget.minValue);
    Debug().info(
        "NumberPicker#$hashCode received to build ${widget.itemCount} pickers for max of ${widget.maxValue}");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("Number ${_combineDigits()}"),
        strut(height: 16),
        Row(
          children: <Widget>[
            for (int i = 0; i < widget.itemCount; i++)
              NumberPicker(
                infiniteLoop: widget.infiniteLoop,
                axis: widget.alignment ?? Axis.vertical,
                minValue: 0,
                maxValue: 9,
                value: _valueCounts[i],
                onChanged: (int value) {
                  setState(() => _valueCounts[i] = value);
                  widget.onChange.call(_combineDigits());
                },
              ),
          ],
        ),
      ],
    );
  }

  int _combineDigits() {
    int result = 0;
    for (int value in _valueCounts) {
      result = result * 10 + value;
    }
    return result;
  }
}

Future<void> launchNumberPickerDialog(BuildContext context,
        {required int minValue,
        required int maxValue,
        int? itemCount,
        Icon? headerIcon,
        bool infiniteLoop = true,
        Axis? alignment,
        required String headerMessage,
        String? comment,
        required void Function(int res) onChange}) async =>
    await showDialog(
        context: context,
        builder: (BuildContext context) => Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                children: <Widget>[
                  AlertDialog(
                      actions: <Widget>[
                        TextButton.icon(
                            onPressed: () =>
                                Navigator.of(context).pop(),
                            icon: const Icon(Icons.check_rounded),
                            label: const Text("OK")),
                      ],
                      icon: headerIcon,
                      title: Text(headerMessage),
                      content: Wrap(children: <Widget>[
                        _InternalNumberPicker(
                            infiniteLoop: infiniteLoop,
                            alignment: alignment,
                            itemCount: itemCount ??
                                maxValue.abs().toString().length,
                            minValue: minValue,
                            maxValue: maxValue,
                            onChange: onChange),
                      ])),
                ]));

@pragma("vm:prefer-inline")
Widget preferTonalButton(
        {required void Function() onPressed,
        required Widget label,
        ButtonStyle? style,
        required Widget icon}) =>
    UserTelemetry().currentModel.preferTonal
        ? FilledButton.tonalIcon(
            onPressed: onPressed,
            icon: icon,
            style: style,
            label: label)
        : TextButton.icon(
            onPressed: onPressed,
            icon: icon,
            style: style,
            label: label);

@pragma("vm:prefer-inline")
SnackBar yummyWarningSnackBar(String message, [double width = 300]) =>
    yummySnackBar(
        message: message,
        backgroundColor: Colors.amber[200],
        width: width,
        icon: const Icon(Icons.warning_rounded, color: Colors.black));

@pragma("vm:prefer-inline")
SnackBar yummyDeadlySnackBar(String message, [double width = 300]) =>
    yummySnackBar(
        message: message,
        width: width,
        backgroundColor: Colors.red[200],
        icon: const Icon(Icons.cancel_rounded, color: Colors.black));

@pragma("vm:prefer-inline")
SnackBar yummySnackBar(
        {Color? backgroundColor,
        Icon? icon,
        required String message,
        bool showCloseIcon = true,
        EdgeInsetsGeometry? margin = const EdgeInsets.only(
            left: 40, right: 40, top: 2, bottom: 2),
        Duration duration = const Duration(milliseconds: 2400),
        TextStyle textStyle = const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors
                .black), // lmao not following material design here
        double? width}) =>
    SnackBar(
        backgroundColor: backgroundColor,
        width: margin == null ? width : null,
        behavior: SnackBarBehavior.floating,
        margin: margin,
        duration: duration,
        showCloseIcon: showCloseIcon,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        content: Tooltip(
          message: message,
          child: Row(children: <Widget>[
            if (icon != null) icon,
            strut(width: 30),
            Text(message,
                style: textStyle, overflow: TextOverflow.ellipsis)
          ]),
        ));

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
