import "package:flutter/material.dart";
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:scouting_app_2024/debug.dart';

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
