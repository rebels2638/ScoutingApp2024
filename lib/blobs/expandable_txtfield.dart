import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/blobs/hints_blob.dart';
import 'package:scouting_app_2024/debug.dart';
import 'package:scouting_app_2024/extern/string.dart';
import 'package:scouting_app_2024/parts/bits/show_hints.dart';
import 'package:scouting_app_2024/user/models/shared.dart';
import 'package:theme_provider/theme_provider.dart';

class ExpandedTextFieldBlob extends StatefulWidget {
  final BuildContext parentContext;
  final String initialData;
  final void Function(String data) onChanged;
  final String hintText;
  final int maxLines;
  final String labelText;
  final String? dialogTitleText;
  final Widget? prefixIcon;
  final int? maxChars;

  const ExpandedTextFieldBlob(this.parentContext,
      {super.key,
      required this.initialData,
      this.prefixIcon,
      this.labelText = "Enter input",
      this.dialogTitleText,
      this.maxChars, // if set to null, then no max chars
      required this.onChanged,
      required this.hintText,
      required this.maxLines});

  @override
  State<ExpandedTextFieldBlob> createState() =>
      _ExpandedTextFieldBlobState();
}

class _ExpandedTextFieldBlobState
    extends State<ExpandedTextFieldBlob> {
  late TextEditingController _controller;
  late bool _badText;
  int _characterCount =
      0; // Add this variable to store character count

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialData);
    _badText = false;
    _characterCount =
        widget.initialData.length; // Update character count initially
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      Widget r = OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.only(
              left: 6, right: 6, top: 10, bottom: 10),
        ),
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: <Widget>[
                      if (widget.prefixIcon != null)
                        widget.prefixIcon!,
                      const SizedBox(width: 6),
                      Text(
                          widget.dialogTitleText ?? widget.labelText),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        if (ShowHintsGuideModal.isShowingHints(
                                context) &&
                            widget.maxChars != null)
                          const WarningHintsBlob(
                              "Do not exceed the character limit",
                              "If you exceed the character limit of $COMMENTS_MAX_CHARS, your data will be truncated to fit the limit."),
                        const SizedBox(height: 20),
                        Text(
                          widget.labelText,
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    color: ThemeProvider.themeOf(
                                            widget.parentContext)
                                        .data
                                        .colorScheme
                                        .primary),
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Text(
                                      "Character Limit: $_characterCount/${widget.maxChars ?? "∞"}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: ThemeProvider
                                                  .themeOf(widget
                                                      .parentContext)
                                              .data
                                              .colorScheme
                                              .onPrimary)),
                                )),
                            const Spacer(), // some more scuffed shit
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          decoration: InputDecoration(
                            hintText: widget.hintText,
                            errorText: _badText
                                ? "Character Limit Exceeded"
                                : null,
                            border: const OutlineInputBorder(),
                          ),
                          controller: _controller,
                          maxLines: widget.maxLines,
                          onChanged: (String data) {
                            if (widget.maxChars != null) {
                              if (data.length > widget.maxChars!) {
                                setState(() {
                                  _characterCount = data.length;
                                  _badText = true;
                                });
                                widget.onChanged.call(data.substring(
                                    0, widget.maxChars!));
                                Debug().warn(
                                    "Content for $hashCode [EXP_TXTFIELD] was truncated to ${widget.maxChars} characters.");
                                return;
                              }
                            }
                            setState(() {
                              _badText = false;
                              _controller.text = data;
                              _characterCount = data
                                  .length; // Update character count
                            });
                            widget.onChanged.call(data);
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            ElevatedButton.icon(
                                onPressed: () async =>
                                    await launchConfirmDialog(context,
                                        message: const Text(
                                            "Are you sure you want to delete all of your comments?",
                                            textAlign:
                                                TextAlign.center),
                                        onConfirm: () {
                                      _controller.clear();
                                      widget.onChanged.call("");
                                      setState(
                                          () => _characterCount = 0);
                                    }),
                                icon: const Icon(Icons.clear_rounded),
                                label: const Text("Clear")),
                            const Spacer(),
                            ElevatedButton.icon(
                                onPressed: () =>
                                    Navigator.of(context).pop(),
                                icon: const Icon(Icons.check_rounded),
                                label: const Text("Done")),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.prefixIcon != null) widget.prefixIcon!,
              if (widget.prefixIcon != null) const SizedBox(width: 6),
              _controller.text.trim().getConstrained(26).isEmpty
                  ? const Text("Tap here to enter data...")
                  : Text(
                      _controller.text.trim().getConstrained(26),
                      softWrap: true,
                    ),
            ],
          ),
        ),
      );
      return widget.maxChars != null
          ? Column(
              children: <Widget>[
                r,
                const SizedBox(height: 4),
                Text(
                  "$_characterCount/${widget.maxChars}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            )
          : r;
    });
  }
}
