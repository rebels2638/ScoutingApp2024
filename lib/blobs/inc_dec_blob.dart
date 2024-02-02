import 'package:flutter/material.dart';
import 'package:scouting_app_2024/blobs/blobs.dart';
import 'package:scouting_app_2024/extern/color.dart';
import 'package:theme_provider/theme_provider.dart';

class PlusMinus extends StatefulWidget {
  final int initialValue;
  final void Function(int)?
      onValueChanged; // callback to return value

  const PlusMinus(
      {super.key, this.initialValue = 0, this.onValueChanged});

  @override
  // ignore: library_private_types_in_public_api
  _PlusMinusState createState() => _PlusMinusState();
}

class _PlusMinusState extends State<PlusMinus> {
  late int _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: strutAll(<Widget>[
        if (_val > 0)
          Tooltip(
            message: "Reset value to 0",
            child: OutlinedButton(
              onPressed: () {
                setState(() => _val = 0);
                widget.onValueChanged?.call(_val);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary,
                    width: 2),
              ),
              child: Text("0",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary)),
            ),
          ),
        Tooltip(
          message: "Decrement value by 1",
          child: OutlinedButton(
            onPressed: () {
              int newVal = _val - 1;
              if (newVal >= 0) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              side: BorderSide(
                  color: _val == 0
                      ? ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary
                          .grayScale()
                      : ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary,
                  width: 2),
            ),
            child: _val == 0
                ? Text("-",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ThemeProvider.themeOf(context)
                            .data
                            .colorScheme
                            .primary
                            .grayScale()))
                : const Text("-",
                    style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
        Text(_val.toString(), style: const TextStyle(fontSize: 20)),
        Tooltip(
          message: "Increment value by 1",
          child: OutlinedButton(
            onPressed: () {
              int newVal = _val + 1;
              if (newVal <= 99) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              side: BorderSide(
                  color: ThemeProvider.themeOf(context)
                      .data
                      .colorScheme
                      .primary,
                  width: 2),
            ),
            child: const Text("+",
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ], width: 8),
    );
  }
}

class PlusMinusRating extends StatefulWidget {
  final int initialValue;
  final void Function(int)?
      onValueChanged; // callback to return value

  const PlusMinusRating(
      {super.key, this.initialValue = 0, this.onValueChanged});

  @override
  // ignore: library_private_types_in_public_api
  _PlusMinusRatingState createState() => _PlusMinusRatingState();
}

class _PlusMinusRatingState extends State<PlusMinusRating> {
  late int _val;

  @override
  void initState() {
    super.initState();
    _val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: strutAll(<Widget>[
        if (_val > 0)
          Tooltip(
            message: "Reset value to 0",
            child: OutlinedButton(
              onPressed: () {
                setState(() => _val = 0);
                widget.onValueChanged?.call(_val);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(
                    color: ThemeProvider.themeOf(context)
                        .data
                        .colorScheme
                        .primary,
                    width: 2),
              ),
              child: Text("0",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary)),
            ),
          ),
        Tooltip(
          message: "Decrement value by 1",
          child: OutlinedButton(
            onPressed: () {
              int newVal = _val - 1;
              if (newVal >= 0) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              side: BorderSide(
                  color: _val == 0
                      ? ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary
                          .grayScale()
                      : ThemeProvider.themeOf(context)
                          .data
                          .colorScheme
                          .primary,
                  width: 2),
            ),
            child: _val == 0
                ? Text("-",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: ThemeProvider.themeOf(context)
                            .data
                            .colorScheme
                            .primary
                            .grayScale()))
                : const Text("-",
                    style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
        Text(_val.toString(), style: const TextStyle(fontSize: 20)),
        Tooltip(
          message: "Increment value by 1",
          child: OutlinedButton(
            onPressed: () {
              int newVal = _val + 1;
              if (newVal <= 10) {
                setState(() => _val = newVal);
                widget.onValueChanged?.call(_val);
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              side: BorderSide(
                  color: ThemeProvider.themeOf(context)
                      .data
                      .colorScheme
                      .primary,
                  width: 2),
            ),
            child: const Text("+",
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
        ),
      ], width: 8),
    );
  }
}
