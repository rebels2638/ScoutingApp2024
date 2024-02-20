import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AssuredConfirmDialogViewInput extends StatefulWidget {
  final String requiredWord;
  final String message;
  final String title;
  final Icon icon;
  final Function()? onCancel;
  final Function()? onConfirm;

  const AssuredConfirmDialogViewInput(
      {super.key,
      required this.requiredWord,
      required this.message,
      required this.title,
      required this.icon,
      this.onCancel,
      this.onConfirm});

  @override
  State<AssuredConfirmDialogViewInput> createState() =>
      _AssuredConfirmDialogViewInputState();
}

class _AssuredConfirmDialogViewInputState
    extends State<AssuredConfirmDialogViewInput> {
  late bool _failed;
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _failed = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      actions: <Widget>[
        TextButton.icon(
            onPressed: () {
              if (_controller.text == widget.requiredWord) {
                widget.onConfirm?.call();
                Navigator.of(context).pop();
              } else {
                setState(() => _failed = true);
              }
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text("Confirm")),
        TextButton.icon(
            onPressed: () {
              widget.onCancel?.call();
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.cancel_rounded),
            label: const Text("Cancel")),
      ],
      icon: widget.icon,
      content:
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text.rich(
          TextSpan(text: widget.message, children: <InlineSpan>[
            const TextSpan(text: "\nType "),
            TextSpan(
                text: widget.requiredWord,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                    backgroundColor: Colors.black)),
            const TextSpan(text: " to confirm:")
          ]),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
              errorMaxLines: 2,
              errorText: _failed
                  ? "Type the word ${widget.requiredWord}"
                  : null,
             ),
        )
      ]),
    );
  }
}
