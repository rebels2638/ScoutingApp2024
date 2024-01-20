import "package:flutter/material.dart";
import "package:scouting_app_2024/blobs/debug.dart";


/// creates a strut, aka a sizedbox
@pragma("vm:prefer-inline")
Widget strut({double? width, double? height}) =>
    SizedBox(width: width, height: height);

/// generic confirmation dialog
@pragma("vm:prefer-inline")
Future<void> launchConfirmDialog(BuildContext context,
    {required Widget message,
    required void Function() onConfirm,
    void Function()? onDeny}) async {
  Debug().info(
      "Launched a CONFIRM_DIALOG with ${message.hashCode}"); // we use the provided context
  await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
              icon: const Icon(Icons.warning_amber_rounded),
              title: const Text("Are you sure?"),
              content: message,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.check_rounded),
                  label: const Text("Yes",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () {
                    onConfirm.call();
                    Navigator.of(context).pop();
                    Debug().info(
                        "CONFIRM_DIALOG ${message.hashCode} ended with CONFIRM");
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.not_interested_rounded),
                  label: const Text("No",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  onPressed: () {
                    onDeny?.call();
                    Navigator.of(context).pop();
                    Debug().info(
                        "CONFIRM_DIALOG ${message.key} ended with DENY");
                  },
                )
              ]));
}

